Shader "Custom/Water"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "white"{}
        _BumpScale("Bump Scale", Float) = 1
        _WaveFrequency("Wave Frequency", Float) = 1
        _WaveScale("Wave Scale", Float) = 1
        _WaterTransparency("Water Transparency", Range(0,1)) = 0.5
        _ScrollSpeed("Scroll Speed", Float) = 1
        _SpecColor("Specular Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

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
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 tangentWS : TEXCOORD3;
                float3 biTangentWS : TEXCOORD4;
                float3 viewDirWS : TEXCOORD5;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            
            TEXTURE2D(_NormalMap);
            SAMPLER(sampler_NormalMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                half _BumpScale;
                half _WaveFrequency;
                half _WaveScale;
                half _WaterTransparency;
                half _ScrollSpeed;
                half4 _SpecColor;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                float3 posWS = TransformObjectToWorld(IN.positionOS);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.uv = IN.uv;
                OUT.tangentWS = TransformObjectToWorldNormal(IN.tangentOS);
                OUT.biTangentWS = cross(OUT.normalWS, OUT.tangentWS) * IN.tangentOS.w;
                OUT.viewDirWS = normalize(GetCameraPositionWS() - posWS);
                
                //if normal is pointing up make wave
                if (posWS.y > 5)
                {
                    float wave = cos(posWS.z + _Time.y * _WaveFrequency) * _WaveScale;
                    posWS.y += wave;
                }
                
                OUT.positionWS = posWS;
                OUT.positionHCS = TransformWorldToHClip(posWS);
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                //get bump stuff to work
                half3 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv + _ScrollSpeed * _Time.y) * _BaseColor;
                half3 normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, IN.uv + _ScrollSpeed * _Time.y));
                normalTS.xy *= _BumpScale;
                
                half3x3 TBN = half3x3(IN.tangentWS, IN.biTangentWS, IN.normalWS);
                half3 normalWS = normalize(mul(normalTS, TBN));
                
                //add lighting
                Light mainLight = GetMainLight();
                half3 lightDir = normalize(mainLight.direction);
                
                half diffuse = max(saturate(dot(normalWS, lightDir)), .1);
                
                //specular
                float3 reflectDir = reflect(-lightDir, normalWS);
                float specFactor = pow(saturate(dot(reflectDir, IN.viewDirWS)), 6);
                float3 specular = _SpecColor * specFactor;
                
                
                
                
                //scroll texture with normal map
                
                half3 finalColor = color * diffuse + specular;
                return half4(finalColor.rgb, _WaterTransparency);
            }
            ENDHLSL
        }
    }
}
