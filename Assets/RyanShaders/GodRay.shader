Shader "Custom/GodRay"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _Transparency("Transparency", Range(0,1)) = .5
        _Emission("Emission Scale", Float) = 1
        [HDR] _EmissionColor("Emission Color", Color) = (1,1,1,1)
        [HDR] _FresnelColor("Fresnel Emission Color", Color) = (1,1,1,1)
        _FresnelPower("Fresnel Power", Float) = 1
        _TopHeight("Top Height", Float) = 1
        // add transparency
        // add color 
        // add color gradient
        // add emission
        // 
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "RenderPipeline" = "UniversalPipeline" "Queue" = "Transparent"}

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS: NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float3 positionWS : TEXCOORD2;
                float3 viewDirWS : TEXCOORD3;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float _Transparency;
                float _Emission;
                half4 _EmissionColor;
                half4 _FresnelColor;
                half _FresnelPower;
                half _TopHeight;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - OUT.positionWS);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv) * _BaseColor;
                half4 glowColor = _Emission * _EmissionColor;
                
                //fresnel stuff
                float NdotV = saturate(dot(IN.normalWS, IN.viewDirWS));
                float fresnel = pow(1.0 - NdotV, _FresnelPower);
                
                color = color + (_FresnelColor * fresnel);
                
                float transparencyPositionMod = IN.positionWS.y / _TopHeight;   
                
                return half4(color.rgb, _Transparency * transparencyPositionMod);
            }
            ENDHLSL
        }
    }
}
