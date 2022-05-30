#ifndef _NOISE
#define _NOISE

float rand(float2 p)
{
    return frac(sin(dot(p,float2(12.9898,78.233)))*43758.5453);
}

float randomNoise(float2 p)
{
    return rand(p);
}

float blockNoise(float2 p, float s)
{
    p=floor(p*s);
    return rand(p);
}

#endif