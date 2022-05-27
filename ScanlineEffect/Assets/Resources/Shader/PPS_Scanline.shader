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

            TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

            float _DistortPower;
            float _Brightness;
            uint _LineAmount;
            float _UseVignette;
            

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

            float3 vignette(float2 p,float3 col)
            {
                p=abs(p*2.-1.);
                p=pow(p,15);
                return lerp(col.rgb, (0.).xxx, p.x+p.y);
            }

            float4 Frag (VaryingsDefault i) : SV_Target
            {
                float2 p=distort(i.texcoord);
                
                float4 mainTexCol=SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, p);


                float lineCol=sin(i.texcoord.y*_LineAmount);
                lineCol=remap(lineCol,float2(-1.,1),float2(_Brightness,1.));

                mainTexCol.rgb*=lineCol;

                mainTexCol.rgb = _UseVignette == 1. ? vignette(p,mainTexCol.rgb) : mainTexCol.rgb;
                // mainTexCol.rgb=vignette(p,mainTexCol.rgb);
                return mainTexCol;
            }
            ENDHLSL
        }
    }
}
