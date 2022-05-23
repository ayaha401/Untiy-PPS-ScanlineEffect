Shader "Unlit/test"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;

			float2 barrel(float2 uv) {
				float s1 = .99, s2 = .125;
				float2 centre = 2. * uv - 1.;
				float barrel = min(1. - length(centre) * s1, 1.0) * s2;
				return uv - centre * barrel;
			}

			float2 distort(float2 p)
			{
				p = p * 2. - 1.;
				float theta = atan2(p.y, p.x);
				float r = length(p);
				r = pow(r, 1.08);
				p.x = r * cos(theta);
				p.y = r * sin(theta);
				return .5* (p + 1.);
			}

			float2 CRT(float2 uv)
			{
				float2 nu = uv * 2. - 1.;
				float2 offset = abs(nu.yx) / float2(6., 4.);
				nu += nu * offset * offset;
				return nu;
			}

			float remap(float val, float2 inMinMax, float2 outMinMax)
			{
				return clamp(outMinMax.x + (val - inMinMax.x) * (outMinMax.y - outMinMax.x) / (inMinMax.y - inMinMax.x), outMinMax.x, outMinMax.y);
			}

			float Scanline(float2 uv)
			{
				float lineCol = sin(uv.y * 400.0);
				lineCol = remap(lineCol, float2(-1., 1), float2(0.8, 1.));
				return lineCol;
			}

			fixed4 frag(v2f_img i) : SV_Target
			{
				// barrel distortion
				float2 p = distort(i.uv);
				fixed4 col = tex2D(_MainTex, p);

				// color grading
			/*	col.rgb *= float3(1.25, 0.95, 0.7);
				col.rgb = clamp(col.rgb, 0.0, 1.0);
				col.rgb = col.rgb * col.rgb * (3.0 - 2.0 * col.rgb);
				col.rgb = 0.5 + 0.5 * col.rgb;*/

				// scanline
				col.rgb *= Scanline(i.uv);

				// crt monitor
				/*float2 crt = CRT(i.uv);
				crt = abs(crt);
				crt = pow(crt, 15.);
				col.rgb = lerp(col.rgb, (.0).xxx, crt.x + crt.y);*/

				// gammma correction
				//col.rgb = pow(col.rgb, (.4545).xxx);

				return col;
			}
			ENDCG
		}
	}
}
