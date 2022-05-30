using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using System;

[Serializable]
[PostProcess(typeof(ScanlineRenderer), PostProcessEvent.AfterStack, "Custom/PPS_Scanline", true)]
public class Scanline : PostProcessEffectSettings
{
    [Range(0.0f, 1.0f)] public FloatParameter distortPower = new FloatParameter { value = 0.0f };
    [Range(0.0f,1.0f)]public FloatParameter brightness = new FloatParameter{ value = 0.8f };
    public IntParameter lineAmount = new IntParameter{value = 400};
    public IntParameter lineMoveSpeed = new IntParameter { value = 100 };

    public BoolParameter useVignette = new BoolParameter { value = true };
}
