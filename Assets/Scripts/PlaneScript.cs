using UnityEngine;

public class PlaneScript : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public GameObject propeller;
    public float maxPropellerSpeed;
    public float propellerspeed;
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.W) && propellerspeed != maxPropellerSpeed)
        {
            propellerspeed += 1f * Time.deltaTime;
        }
        else if (!Input.GetKey(KeyCode.W) && propellerspeed > 0)
        {
            propellerspeed -= 1f * Time.deltaTime;
        }
        else
        {
            Debug.Log("done or not working");
        }
        propeller.transform.Rotate(new Vector3(0, propellerspeed, 0));
    }
}
