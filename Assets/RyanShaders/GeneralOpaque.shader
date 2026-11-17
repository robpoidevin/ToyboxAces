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
        _SmoothnessMap("Smoothness Map", 2D) = "white"{}
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
            
            TEXTURE2D(_SmoothnessMap);
            SAMPLER(sampler_SmoothnessMap);

            CBUFFER_START(UnityPerMaterial)
                //albedo dependencies
                half4 _Tint;
                //emission dependencies
                half _GlowScale;
                half4 _GlowColor;
            CBUFFER_END

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
                
                half4 color = albedo * glowColor;
                
                return color;
            }
            ENDHLSL
        }

        //shadows
        UsePass "Universal Render Pipeline/Lit/ShadowCaster"
    }
}
