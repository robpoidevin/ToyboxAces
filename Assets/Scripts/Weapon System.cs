using UnityEngine;

public class WeaponSystem : MonoBehaviour
{
    public GameObject missle;
    Vector3 misslePos = new Vector3(0, -0.02f, 0);
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if (Input.GetKeyDown(KeyCode.E))
        {
            Instantiate(missle, transform.position + misslePos, transform.rotation * Quaternion.Euler(90, 0, 0));
            
        }
    }
}
