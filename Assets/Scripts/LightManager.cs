using System.Collections.Generic;
using UnityEngine;

public class LightManager : MonoBehaviour
{
    [SerializeField] List<Renderer> lightToggleObjects = new List<Renderer>(); // has all the lit gameobjects that can be toggled
    
    void Update()
    {
        if (Input.anyKeyDown)
        {
            int lightModeValue = -1;
            //listen for player to change light modes
            //if press 0 light mode goes to default for every object
            if (Input.GetKeyDown(KeyCode.Alpha0))
            {
                lightModeValue = 0;
            }
            // press 1 for no lighting
            else if (Input.GetKeyDown(KeyCode.Alpha1))
            {
                lightModeValue = 1;
            }
            // press 2 for diffuse lighting
            else if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                lightModeValue = 2;
            }
            //press 3 for specular lighting
            else if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                lightModeValue = 3;
            }
            //press 4 for ambient lighting
            else if (Input.GetKeyDown(KeyCode.Alpha4))
            {
                lightModeValue = 4;
            }
            //press 5 for all lighting
            else if (Input.GetKeyDown(KeyCode.Alpha5))
            {
                lightModeValue = 5;
            }
            //press 6 for all lighting plus special effect (undecided)
            else if (Input.GetKeyDown(KeyCode.Alpha6))
            {
                lightModeValue = 6;
            }

            if (lightModeValue != -1)
            {
                foreach (Renderer litObject in lightToggleObjects)
                {
                    if (lightModeValue == 0)
                    {
                        litObject.material.SetFloat("_CurrentLightingMode",litObject.material.GetFloat("_DefaultLightingMode"));
                    }
                    else
                    {
                        litObject.material.SetFloat("_CurrentLightingMode", lightModeValue);
                    }
                    
                }
            }
        }
        
    }
}
