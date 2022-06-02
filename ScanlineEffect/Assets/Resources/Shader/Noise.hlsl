#ifndef _NOISE
#define _NOISE

float rand(float2 uv)
{
    return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
}

float f1Rand2(float2 uv)
{
    uv=float2(dot(uv,float2(127.1,311.7)),
              dot(uv,float2(269.5,183.3)));
    return -1.+2.*frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
}

float2 f2rand2(float2 uv)
{
    uv=float2(dot(uv,float2(127.1,311.7)),
              dot(uv,float2(269.5,183.3)));
    return -1.+2.*frac(sin(uv)*43758.5453123);
}

float randomNoise(float2 uv)
{
    return rand(uv);
}

float blockNoise(float2 uv, float s)
{
    uv=floor(uv*s);
    return rand(uv);
}

float valueNoise(float2 uv, float s)
{
    float2 i=floor(uv*s);
    float2 f=frac(uv*s);

    float v00=f1Rand2(i+float2(0.,0.));
    float v10=f1Rand2(i+float2(1.,0.));
    float v01=f1Rand2(i+float2(0.,1.));
    float v11=f1Rand2(i+float2(1.,1.));

    float2 u=f*f*(3.-2.*f);

    float v0010 = lerp(v00, v10, u.x);
    float v0111 = lerp(v01, v11, u.x);

    return lerp(v0010, v0111, u.y)*.5+.5;
}

float perlinNoise(float2 uv,float s)
{
    float2 i=floor(uv*s);
    float2 f=frac(uv*s);

    float2 u=f*f*(3.-2.*f);

    float2 v00=f2rand2(i+float2(0.,0.));
    float2 v10=f2rand2(i+float2(1.,0.));
    float2 v01=f2rand2(i+float2(0.,1.));
    float2 v11=f2rand2(i+float2(1.,1.));

    return lerp(lerp(dot(v00, f-float2(0.,0.)),
                     dot(v10, f-float2(1.,0.)), u.x),
                lerp(dot(v01, f-float2(0.,1.)),
                     dot(v11, f-float2(1.,1.)), u.x), u.y)*.5+.5;
}


#endif