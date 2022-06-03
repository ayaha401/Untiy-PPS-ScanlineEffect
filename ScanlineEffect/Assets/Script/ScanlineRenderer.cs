using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using System;

public class ScanlineRenderer : PostProcessEffectRenderer<Scanline>
{
    public override void Init()
    {
        base.Init();
    }

    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Custom/PPS_Scanline"));

        sheet.properties.SetFloat("_DistortPower", settings.distortPower);

        sheet.properties.SetFloat("_Brightness", settings.brightness);
        sheet.properties.SetInt("_LineAmount", settings.lineAmount);
        sheet.properties.SetFloat("_LineMoveSpeed", settings.lineMoveSpeed);

        
        float vignetteToggle = settings.useVignette == true ? 1.0f : 0.0f;
        sheet.properties.SetFloat("_UseVignette", vignetteToggle);

        float glitchToggle = settings.useGlitch == true ? 1.0f : 0.0f;
        sheet.properties.SetFloat("_UseGlitch", glitchToggle);

        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }

    public override void Release()
    {
        base.Release();
    }
}
