using UnityEngine;
using System.Collections.Generic;

public class ColorGradingSwap : MonoBehaviour
{
    public Material colorGradingMaterial;
    [SerializeField] List<Texture2D> luts = new List<Texture2D>();

    public int currentLUTPosition = 0;
    // Update is called once per frame
    void Update()
    {
        if (Input.anyKeyDown)
        {
            if (Input.GetKey(KeyCode.Q))
            { 
                currentLUTPosition = (currentLUTPosition + 1) % luts.Count;
                //check if zero
                if (currentLUTPosition == 0)
                {
                    colorGradingMaterial.SetFloat("_Contribution", 0);
                }
                else
                {
                    colorGradingMaterial.SetTexture("_LUT", luts[currentLUTPosition]);   
                    colorGradingMaterial.SetFloat("_Contribution", 0.3f);
                }
            }
        }
    }
}
