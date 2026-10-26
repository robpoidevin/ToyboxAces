Shader "Custom/LightToggle"
{
    Properties
    {
        //stuff for color and height map
        _DiffuseMap("Diffuse Map", 2D) = "white"{}
        _BumpMap("Bump Map", 2D) = "white" {}
        _BumpScale("Bump Scale", Float) = 1
        
        //stuff to make the light modes switch
        _CurrentLightingMode("Lighting Mode", Float) = 0
        _DefaultLightingMode("Default Lighting Mode", Float) = 0
        
        //stuff to make the light stuff work
        _DiffuseMultiplier("Diffuse Multiplier", Float) = 1
        
        _AmbientMultiplier("Ambient Multiplier", Float) = 0.2
        
        _Shininess("Shininess", Float) = 6
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        
        //stuff to make hdr color effect work
        [HDR] _GlowColor("Glow Color", Color) = (1,1,1,1)
        _GlowPower("Glow Power", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            //for additional lights alongside main light
            #pragma multi_compile _ _ADDITIONAL_LIGHTS

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float3 tangentWS : TEXCOORD3;
                float3 positionWS: TEXCOORD2;
                float3 biTangentWS : TEXCOORD4;
                float3 viewDirWS : TEXCOORD5;
            };

            TEXTURE2D(_DiffuseMap);
            SAMPLER(sampler_DiffuseMap);
            
            TEXTURE2D(_BumpMap);
            SAMPLER(sampler_BumpMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _DiffuseMap_ST;
                half4 _BumpMap_ST;
                half _BumpScale;
                half _CurrentLightingMode;
                half _DefaultLightingMode;
                half _DiffuseMultiplier;
                half _AmbientMultiplier;
                half4 _GlowColor;
                half _GlowPower;
                half _Shininess;
                half4 _SpecColor;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                OUT.tangentWS = TransformObjectToWorldNormal(IN.tangentOS.xyz);
                OUT.biTangentWS = cross(OUT.normalWS, OUT.tangentWS) * IN.tangentOS.w;
                OUT.viewDirWS = normalize(GetCameraPositionWS() - OUT.positionWS);
                OUT.uv = IN.uv;
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                //setting the diffuse and bump maps
                half3 color = SAMPLE_TEXTURE2D(_DiffuseMap, sampler_DiffuseMap, IN.uv);
                half3 normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, IN.uv));
                normalTS.xy *= _BumpScale;
                
                //tangent space normal to world space 
                half3x3 TBN = half3x3(IN.tangentWS, IN.biTangentWS, IN.normalWS);
                half3 normalWS = normalize(mul(normalTS, TBN));
                
                half colorMultiplier = 1;
                half colorAddition = 0;
                
                //get light info
                Light mainLight = GetMainLight();
                half3 lightDir = normalize(mainLight.direction);
                
                switch (_CurrentLightingMode)
                {
                //diffuse lighting
                case 2:
                    {
                        half NdotL = saturate(dot(normalWS, lightDir));
                        //make shadows less dark
                        
                        colorMultiplier = max(NdotL * _DiffuseMultiplier, 0.2);
                        break;
                    }
                //specular lighting
                case 3:
                    {
                        half3 reflectDir = reflect(-lightDir, normalWS);
                        half3 viewDir = normalize(IN.viewDirWS);
                        half specFactor = pow(saturate(dot(reflectDir, viewDir)), _Shininess);
                        half3 specular = _SpecColor * specFactor;
                        colorAddition += specular;
                        break;
                    }
                //ambient lighting
                case 4:
                    {
                        colorAddition = saturate(SampleSH(normalWS) * _AmbientMultiplier);
                        break;
                    }
                //all lighting
                case 5:
                    {
                    half NdotL = saturate(dot(normalWS, lightDir));
                    colorMultiplier = NdotL * _DiffuseMultiplier;
                        
                    colorAddition += saturate(SampleSH(normalWS) * _AmbientMultiplier);
                        
                    half3 reflectDir = reflect(-lightDir, normalWS);
                        half3 viewDir = normalize(IN.viewDirWS);
                        half specFactor = pow(saturate(dot(reflectDir, viewDir)), _Shininess);
                        half3 specular = _SpecColor * specFactor;
                        colorAddition = (colorAddition + specular) / 2;
                        
                    break;
                    }
           
                //all lighting + effect
                case 6:
                    half NdotL = saturate(dot(normalWS, lightDir));
                    colorMultiplier = NdotL * _DiffuseMultiplier;
                        
                    colorAddition += SampleSH(normalWS) * _AmbientMultiplier;
                        
                    half3 reflectDir = reflect(-lightDir, normalWS);
                        half3 viewDir = normalize(IN.viewDirWS);
                        half specFactor = pow(saturate(dot(reflectDir, viewDir)), _Shininess);
                        half3 specular = _SpecColor * specFactor;
                    colorAddition = (colorAddition + specular) / 2;
                    
                    //extra HDR glow effect
                    colorMultiplier = colorMultiplier *_GlowColor * _GlowPower;
                    break;
                default:
                    break;
                }
                
                color = color * colorMultiplier + colorAddition;
                
                return half4(color,1);
            }
            ENDHLSL
        }
    }
}
