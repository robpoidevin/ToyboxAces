using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class BumpListener : MonoBehaviour
{
    [SerializeField] private List<Renderer> bumpObjects;

    void Start()
    {
        //get bumpobjects from light toggle script
        GameObject lightToggle = GameObject.Find("LightManager");
        bumpObjects = lightToggle.GetComponent<LightManager>().lightToggleObjects;
    }
    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.B))
        {
            foreach (Renderer r in bumpObjects)
            {
                r.material.SetFloat("_IsBumpy", r.material.GetFloat("_IsBumpy") * -1);
            }
        }
    }
}
