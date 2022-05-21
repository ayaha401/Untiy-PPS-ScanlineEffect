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

        sheet.properties.SetFloat("_Brightness", settings.brightness);

        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }

    public override void Release()
    {
        base.Release();
    }
}
