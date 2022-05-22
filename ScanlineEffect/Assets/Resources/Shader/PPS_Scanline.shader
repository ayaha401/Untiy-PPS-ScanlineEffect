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

            float _Brightness;
            uint _LineAmount;

            float remap(float val, float2 inMinMax, float2 outMinMax)
            {
                return clamp(outMinMax.x+(val-inMinMax.x)*(outMinMax.y-outMinMax.x)/(inMinMax.y-inMinMax.x), outMinMax.x, outMinMax.y);
            }

            float4 Frag (VaryingsDefault i) : SV_Target
            {
                float4 mainTexCol=SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

                float lineCol=sin(i.texcoord.y*_LineAmount);
                lineCol=remap(lineCol,float2(-1.,1),float2(_Brightness,1.));
                return mainTexCol*lineCol;
            }
            ENDHLSL
        }
    }
}
