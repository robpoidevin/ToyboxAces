Shader "Custom/GeneralOpaque"
{
    Properties
    {
        //support for albedo map
        _AlbedoMap("Albedo Map", 2D) = "white"{}
        _Tint("Tint Color", Color) = (1,1,1,1)
        //support for Metallic map
        _MetallicMap("Metallic Map", 2D) = "white"{}
        //support for Smoothness map
        _RoughnessMap("Smoothness Map", 2D) = "white"{}
        //support for Normal Map
        [Normal] _NormalMap("Normal Map", 2D) = "white"{}
        //support for emission map
        _EmissionMap("Emission Map", 2D) = "white"{}
        _GlowScale("Emission Scale", Float) = 1
        [HDR] _GlowColor("Glow Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            Tags{"LightMode" = "UniversalForward"}
            //name is referenced in other shader for generic shaders 
            ZWrite On
            Name "MainPass"
            
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            //URP lighting stuff and shadows (used in metal and other attributes)
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
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
                float3 tangentWS : TEXCOORD2;
                float3 biTangentWS : TEXCOORD3;
                float3 viewDirWS : TEXCOORD4;
                float3 positionWS : TEXCOORD5;
            };
    
            TEXTURE2D(_AlbedoMap);
            SAMPLER(sampler_AlbedoMap);
            
            TEXTURE2D(_EmissionMap);
            SAMPLER(sampler_EmissionMap);
            
            TEXTURE2D(_NormalMap);
            SAMPLER(sampler_NormalMap);
            
            TEXTURE2D(_MetallicMap);
            SAMPLER(sampler_MetallicMap);
            
            TEXTURE2D(_RoughnessMap);
            SAMPLER(sampler_RoughnessMap);

            CBUFFER_START(UnityPerMaterial)
                //albedo dependencies
                half4 _Tint;
                //emission dependencies
                half _GlowScale;
                half4 _GlowColor;
            CBUFFER_END

            half3 FresnelSchlick(half cosTheta, half3 specularF0)
            {
                half invCosTheta = (1.0 - cosTheta);
                half pow5 = pow(invCosTheta, 5);
                
                return specularF0 + (1.0 - specularF0) * pow5;
            }
            
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                //idk if these are needed but
                VertexPositionInputs posInputs = GetVertexPositionInputs(IN.positionOS.xyz);
                VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normalOS.xyz);
                
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                OUT.tangentWS = TransformObjectToWorldNormal(IN.tangentOS.xyz);
                OUT.biTangentWS = cross(OUT.normalWS, OUT.tangentWS) * IN.tangentOS.w;
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - OUT.positionWS);
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 albedo = SAMPLE_TEXTURE2D(_AlbedoMap, sampler_AlbedoMap, IN.uv) * _Tint;
                half4 glowColor = SAMPLE_TEXTURE2D(_EmissionMap, sampler_AlbedoMap, IN.uv) * _GlowColor * _GlowScale;
                
                //convert normal from tangent space of map to world space
                half3 normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uv));
                half3x3 TBN = half3x3(IN.tangentWS, IN.biTangentWS, IN.normalWS);
                half3 normalWS = normalize(mul(normalTS, TBN)); //use this for normal calcs
                
                //intializing lights
                Light mainLight = GetMainLight();
                float3 lightDir = normalize(mainLight.direction);
                
                
                //roughness stuff
                half roughness = SAMPLE_TEXTURE2D(_RoughnessMap, sampler_RoughnessMap, IN.uv);
                half metallic = SAMPLE_TEXTURE2D(_MetallicMap, sampler_MetallicMap, IN.uv);
                half smoothness = 1.0 - roughness;
                half3 halfwayVector = normalize(lightDir + IN.viewDirWS);
                
                half4 diffuseColor = albedo * (1.0 - metallic);
                half3 specularF0 = lerp(half3(0.04,0.04,0.04), albedo, metallic);
                
                //angle stuff
                float NdotL = saturate(dot(normalWS, lightDir));
                float NdotH = saturate(dot(normalWS, halfwayVector));
                float NdotV = max(dot(normalWS, IN.viewDirWS), 1e-4);
                float HdotV = saturate(dot(halfwayVector, IN.viewDirWS));
                
                //fresnel and roughness spec power calc
                half3 fresnel = FresnelSchlick(HdotV, specularF0);
                half specPower = exp2(10.0 * smoothness + 1.0);
                half specNorm = (specPower + 8.0) / (8.0 * 3.14159265);
                half3 specular = fresnel * (specNorm * pow(NdotH, specPower));
                
                //energy conservation between diffuse and specular
                half3 kD = saturate(1.0 - fresnel) * (1.0 - metallic);
                half3 diffuse = kD * diffuseColor * (1.0 / 3.14159265);
                
                
                
                half3 color = (diffuse + specular) * mainLight.color * NdotL + glowColor;
                
                return half4(color,1);
            }
            ENDHLSL
        }

        //shadows
        UsePass "Universal Render Pipeline/Lit/ShadowCaster"
    }
}
