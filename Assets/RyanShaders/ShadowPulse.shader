Shader "Custom/ShadowPulse"
{
    Properties
    {
       _BaseColor("Base Color",Color) = (1,1,1,1)
       _ShadowPulse("Shadow Pulse", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}

        UsePass "Universal Render Pipeline/Lit/ShadowCaster"
        
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            //for additional lights alongside main light
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float3 positionWS: TEXCOORD2;

                float3 viewDirWS : TEXCOORD5;
                float4 shadowCoord : TEXCOORD6;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                half _ShadowPulse;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                float3 shadowPos = IN.positionOS + IN.normalOS * sin(_Time.y) * _ShadowPulse;
                shadowPos = TransformObjectToWorld(shadowPos);
                
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - OUT.positionWS);
                
                //shadow stuff
       
                OUT.shadowCoord = TransformWorldToShadowCoord(shadowPos);
                
                OUT.uv = IN.uv;
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                //setting the diffuse and bump maps
                half3 color = _BaseColor;
                
                //get light info
                Light mainLight = GetMainLight(IN.shadowCoord);
                half3 lightDir = normalize(mainLight.direction);
                half4 shadowMask = half4(1,1,1,1);
                
                return half4(color,1);
            }
            ENDHLSL
        }
    }
}
