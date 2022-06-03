Shader "Custom/PPS_Scanline"
{
    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment Frag

            #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
            #include "Noise.hlsl"

            TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

            float _DistortPower;
            float _Brightness;
            uint _LineAmount;
            float _UseVignette;
            float _LineMoveSpeed;
            float _UseGlitch;
            

            float2 distort(float2 p)
            {
                p=p*2.-1.;
                float theta=atan2(p.y,p.x);
                float r=length(p);
                r=pow(r,1.+_DistortPower);
                p.x=r*cos(theta);
                p.y=r*sin(theta);
                return .5*(p+1.);
            }

            float remap(float val, float2 inMinMax, float2 outMinMax)
            {
                return clamp(outMinMax.x+(val-inMinMax.x)*(outMinMax.y-outMinMax.x)/(inMinMax.y-inMinMax.x), outMinMax.x, outMinMax.y);
            }

            float3 vignette(float2 p,float3 col,float flag)
            {
                p=abs(p*2.-1.);
                p=pow(p,15);
                return lerp(col.rgb, (0.).xxx + (col.rgb*(1.-flag)), p.x+p.y);
            }

            float4 Frag (VaryingsDefault i) : SV_Target
            {
                float2 p=distort(i.texcoord);

                float noise = perlinNoise(i.texcoord.yy+_Time.y*10., 10.);
                noise = (noise*2.-1.)*.05;
                
                float strength = pow(perlinNoise((float2)_Time.y, 10.),4.);

                float4 mainTexCol=SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, p+(noise*strength*_UseGlitch));

                float lineCol=sin((i.texcoord.y*_LineAmount)+_Time.y*_LineMoveSpeed);
                lineCol=remap(lineCol,float2(-1.,1),float2(_Brightness,1.));

                mainTexCol.rgb*=lineCol;
                mainTexCol.rgb=vignette(p, mainTexCol.rgb, _UseVignette);
                
                float3 a = (float3)cellularNoise(i.texcoord, 5.);
                return float4(a.xxx,1.);
            }
            ENDHLSL
        }
    }
}
