using System;
using UnityEngine;

public class ColorGradingCamera : MonoBehaviour
{
    public Material lutMaterial;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lutMaterial != null)
        {
            Graphics.Blit(source, destination, lutMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
