Shader "Custom/PlaneBoost"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        
        //light emitter
        [HDR] _GlowColor ("Glow Color", Color) = (1,1,1,1)
        _GlowPower ("Glow Power", Float) = 1
        
        //transparency
        _Transparency("Transparency", Range(0,1)) = 0
        
        //make texture rotate
        _RotationSpeed("Rotation Speed", Float) = 1
        
        //make tips of fire move up and down
        _FlareExcitementFrequency("Flare Excitement Frequency", Float) = 1
        _FlareExcitementPower("Flare Excitement Scale", Float) = 1
        _FlareExcitementThreshold("Flare Excitement Threshold", Float) = 1
        
        //make fire wave slightly
        _FlareWavePower("Flare wave power", Float) = 1
        _FlareWaveFrequency("Flare wave frequency", Float) = 1
        _FlareWaveThreshold("Flare wave threshold", Float) = 1
        
        //Fresnel stuff to make the flame more cartoony
        _RimColor("Rim color", Color) = (1,1,1,1)
        _RimPower("Rim power", Float) = 1
        _RimStrength("rim strength", Float) = 1
        
        //Outline stuff 
        _OutlineWidth("Outline Width", Float) = 1
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
    }

    SubShader
    {
         Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "RenderPipeline" = "UniversalPipeline" }
        
        Pass
        {
            Tags{"LightMode" = "SRPDefaultUnlit"}
            Cull Front
            ZWrite Off
            
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vertOutline
            #pragma fragment fragOutline

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                half4 _GlowColor;
                half _GlowPower;
                half _Transparency;
                half _RotationSpeed;
                half _FlareExcitementThreshold;
                half _FlareExcitementFrequency;
                half _FlareExcitementPower;
                half _FlareWaveFrequency;
                half _FlareWavePower;
                half _FlareWaveThreshold;
                half4 _RimColor;
                half _RimPower;
                half _RimStrength;
                half4 _OutlineColor;
                half _OutlineWidth;
            CBUFFER_END

            float rand(float2 seed)
            {
                return frac(sin(dot(seed, float2(12.9898, 78.233))) * 43758.5453);
            }
            
            Varyings vertOutline(Attributes IN)
            {
                Varyings OUT;
                    
                float3 posOS = IN.positionOS.xyz;    
                //check for flare location
                if (posOS.y > _FlareExcitementThreshold)
                {
                    //do flare calc
                    half flareIncrement = sin((posOS.xy + _FlareExcitementFrequency) * _Time.y) * _FlareExcitementPower;
                    half randomness = rand(_Time.x) * _FlareExcitementPower;
                    
                    
                    //increment vertice by calc
                    posOS.y += flareIncrement + randomness;
                    
                }
                
                if (posOS.y > _FlareWaveThreshold)
                {
                    //flare wave
                    half flareWave = sin((posOS.y + _FlareWaveFrequency) * _Time.y) * _FlareWavePower;
                    half anotherFlareWave = cos((posOS.y + _FlareWaveFrequency) * _Time.y) * _FlareWavePower;
                
                    posOS.x += flareWave;
                    posOS.z += anotherFlareWave;
                }

                OUT.positionHCS = TransformObjectToHClip(posOS.xyz + IN.normalOS * _OutlineWidth);
                return OUT;
            }

            half4 fragOutline(Varyings IN) : SV_Target
            {
                half4 col = _OutlineColor;
                col.a = 1.0;
                return col;
            }
            ENDHLSL
        }
        
        
     

        Pass
        {
            Tags{"LightMode" = "UniversalForward"}
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back
            
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 positionWS : TEXCOORD2;
                float3 normalWS : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                half4 _GlowColor;
                half _GlowPower;
                half _Transparency;
                half _RotationSpeed;
                half _FlareExcitementThreshold;
                half _FlareExcitementFrequency;
                half _FlareExcitementPower;
                half _FlareWaveFrequency;
                half _FlareWavePower;
                half _FlareWaveThreshold;
                half4 _RimColor;
                half _RimPower;
                half _RimStrength;
            CBUFFER_END
            
                float rand(float2 seed)
    {
        return frac(sin(dot(seed, float2(12.9898, 78.233))) * 43758.5453);
    }
            
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                    
                float3 posOS = IN.positionOS.xyz;    
                //check for flare location
                if (posOS.y > _FlareExcitementThreshold)
                {
                    //do flare calc
                    half flareIncrement = sin((posOS.xy + _FlareExcitementFrequency) * _Time.y) * _FlareExcitementPower;
                    half randomness = rand(_Time.x) * _FlareExcitementPower;
                    
                    
                    //increment vertice by calc
                    posOS.y += flareIncrement + randomness;
                    
                }
                
                if (posOS.y > _FlareWaveThreshold)
                {
                    //flare wave
                    half flareWave = sin((posOS.y + _FlareWaveFrequency) * _Time.y) * _FlareWavePower;
                    half anotherFlareWave = cos((posOS.y + _FlareWaveFrequency) * _Time.y) * _FlareWavePower;
                
                    posOS.x += flareWave;
                    posOS.z += anotherFlareWave;
                }
      
                
                OUT.positionHCS = TransformObjectToHClip(posOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.positionWS = TransformObjectToWorld(posOS);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv + _RotationSpeed * _Time.y) * _BaseColor;
                
                //fresnel
                float3 normal = normalize(IN.normalWS);
                float3 viewDirWS = (GetCameraPositionWS() - IN.positionWS.xyz);
                half fresnel = pow(1.0 - saturate(dot(viewDirWS, normal)), _RimPower);
                half4 fresnelColor = _RimColor * fresnel * _RimStrength;
                
                color += fresnelColor;
                
                half4 glow = _GlowColor * _GlowPower;
                color *= glow;
                
                return half4(color.rgb, 1);
            }
            ENDHLSL
        }
    }
}
