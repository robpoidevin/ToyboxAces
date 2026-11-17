Shader "Custom/GeneralOutline"
{
    Properties
    {
        _PrimaryOutline("Primary Outline", Color) = (1,1,1,1)
        _PrimaryWidth("Primary Outline Width", Float) = 1
        _PrimaryVariationScale("Primary Outline Variation Scale", Float) = 1
        _PrimaryVariationFrequency("Primary Outline Variation Frequency", Float) = 1
        _SecondaryOutline("Secondary Outline", Color) = (1,1,1,1)
        _SecondaryWidth("Secondary Outline Width", Float) = 1
        //general opaque shader properties
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
            Name "FirstOutline"
            Tags{"LightMode" = "FirstOutline"}
            Cull Front
            ZWrite On
            
            HLSLPROGRAM
            
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            float Rand(float2 uv)
            {
                return frac(sin(dot(uv + _Time.y, float2(12.9898, 78.233))) * 43758.5453);
            }
            
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
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            
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
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float3 _PrimaryOutline;
                float _PrimaryWidth;
                float _PrimaryVariationScale;
                float _PrimaryVariationFrequency;
                                //albedo dependencies
                half4 _Tint;
                //emission dependencies
                half _GlowScale;
                half4 _GlowColor;
                
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                //outline stuff
                float3 posOS = IN.positionOS;
                
                
                //Random variation
                
                //float randomness = sin(_Time.y) * 0.1 + Rand(IN.uv) * _PrimaryVariationScale;
                
                posOS = posOS + sin(Rand(IN.uv)) * (IN.normalOS * _PrimaryWidth  * _PrimaryVariationScale);
                
                OUT.positionHCS = TransformObjectToHClip(posOS);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return half4(_PrimaryOutline,1);
            }
            ENDHLSL
        }

                Pass
        {
            Name "SecondOutline"
            
            Tags{"LightMode" = "SecondOutline"}
            Cull Front
            ZWrite On
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float3 _SecondaryOutline;
                float _SecondaryWidth;
                float _PrimaryVariationScale;
                float _PrimaryVariationFrequency;
            CBUFFER_END
            
            float Rand(float2 uv)
            {
                return frac(sin(dot(uv + _Time.y, float2(12.9898, 78.233))) * 43758.5453);
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                //outline stuff
                float3 posOS = IN.positionOS;
                posOS = posOS + sin(Rand(IN.uv)) * (IN.normalOS * _SecondaryWidth * _PrimaryVariationScale);
                
                //Random variation
                OUT.positionHCS = TransformObjectToHClip(posOS);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return half4(_SecondaryOutline,1);
            }
            ENDHLSL
        }

 
        UsePass "Custom/GeneralOpaque/MAINPASS"
    }
}
