Shader "Custom/LUTColorGrading"

{

    Properties

    {

        _MainTex ("Texture", 2D) = "white" {}

        _LUT ("LUT", 2D) = "white" {}

        _Contribution ("Contribution", Range(0, 1)) = 1

    }

    SubShader

    {

        // Disable culling, depth writing, and depth testing for full-screen effects

        Cull Off ZWrite Off ZTest Always

        Pass

        {

            HLSLPROGRAM

            #pragma vertex vert

            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
             // LUT is 32 slices of 32x32, arranged horizontally as 512x32
            #define LUT_SIZE 32.0

            struct Attributes
            {
                uint vertexID : SV_VertexID;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // Full Screen Pass uses _BlitTexture for the screen color
            TEXTURE2D(_BlitTexture);
            SAMPLER(sampler_BlitTexture);

            TEXTURE2D(_LUT);
            SAMPLER(sampler_LUT);

            // Texel size for the LUT: (1/width, 1/height, width, height)
            float4 _LUT_TexelSize;
            float _Contribution;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                // Fullscreen triangle generation
                OUT.positionHCS = GetFullScreenTriangleVertexPosition(IN.vertexID);
                OUT.uv = GetFullScreenTriangleTexCoord(IN.vertexID);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // 1. Sample the screen color from URP's blit source
                half4 col = SAMPLE_TEXTURE2D(_BlitTexture, sampler_BlitTexture, IN.uv);

                // 2. Standard LUT strip sampling (matches Unity's ApplyLut2D)
                // LUT height = 32 (the cube size)
                float lutHeight = _LUT_TexelSize.w; // 32
                float lutWidth  = _LUT_TexelSize.z; // 512

                // Scale blue to 0..(lutHeight-1) to find the slice
                float3 uvw = col.rgb;
                uvw.z *= (lutHeight - 1.0);

                // The slice index (which 32x32 tile to read)
                float shift = floor(uvw.z);

                // Calculate UV within the LUT texture
                // uvw.xy are the R and G coordinates inside a single 32x32 slice
                uvw.xy = uvw.xy * (lutHeight - 1.0) * _LUT_TexelSize.xy + _LUT_TexelSize.xy * 0.5;

                // Offset X by the slice index (each slice is 32 pixels wide)
                uvw.x += shift * _LUT_TexelSize.y; // _LUT_TexelSize.y is 1/32

                // Sample both the current slice and the next slice for smooth interpolation
                float3 lutColor0 = SAMPLE_TEXTURE2D(_LUT, sampler_LUT, uvw.xy).rgb;
                float3 lutColor1 = SAMPLE_TEXTURE2D(_LUT, sampler_LUT, uvw.xy + float2(_LUT_TexelSize.y, 0.0)).rgb;

                // Interpolate between slices based on the fractional part of blue
                half3 gradedCol = lerp(lutColor0, lutColor1, uvw.z - shift);

                // 3. Blend with original
                return lerp(col, half4(gradedCol, col.a), _Contribution);
            }
            ENDHLSL
        }

    }

}