using UnityEngine;
using UnityEngine.SceneManagement;

public class PlaneScript : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    Rigidbody rb;
    public bool isNormie;

    [Header("Propeller")]
    public GameObject propeller;
    public float maxPropellerSpeed;
    public float propellerSpeed;
    [Header("Plane")]
    public float maxSpeed;
    public float speed = 100;
    public float turnSpeed;
    public float rollSpeed;
    public float tiltSpeed;
    float pitch;
    float yaw;
    float roll;
    [Header("HUD")]
    public GameObject speedLines;
    public float speedLineThreshold = 2;

    void Awake()
    {
        rb = GetComponent<Rigidbody>();
        rollSpeed = 0.04f;
        tiltSpeed = 0.0008f;
    }

    // Update is called once per frame
    void Update()
    {
        //----------Propeller------------
        if (propellerSpeed != maxPropellerSpeed)
        {
            propellerSpeed += 1f * Time.deltaTime;
        }
        else
        {
            //Debug.Log("done or not working");
        }
        propeller.transform.Rotate(new Vector3(0, propellerSpeed, 0));
        //------------------------------
        //Debug.Log(rb.linearVelocity);

        pitch = Input.GetAxis("Vertical");

        //
        if (!isNormie)
        {
            roll = Input.GetAxis("Horizontal");
            yaw = Input.GetAxis("TurnPlane");
        }
        else
        {
            yaw = Input.GetAxis("Horizontal");
            roll = Input.GetAxis("TurnPlane");
            pitch = pitch * -1;
        }
        
        if (Input.GetKey(KeyCode.Space) && speed > 1)
        {
            maxSpeed = 200;
        }
        else if (!Input.GetKey(KeyCode.Space))
        {
            maxSpeed = 100;
        }

        propellerSpeed = Mathf.Clamp(propellerSpeed, 0f, maxPropellerSpeed);

        if (speed > maxSpeed)
        {
            speed -= 1f;
        }
        if (speed < maxSpeed)
        {
            speed += 1f;
        }
        //transform.Rotate(new Vector3(0, 0, 0.1f));
        //Debug.Log(rb.angularVelocity.z);
        if (speed < speedLineThreshold) 
        { 
            speedLines.SetActive(false); 
        } 
        else 
        { 
            speedLines.SetActive(true); 
        }
    }
    private void FixedUpdate()
    {
        //move plane forward
        rb.AddForce((transform.forward) * speed);
        //makes plane move in the direction the plane
        rb.linearVelocity = transform.forward * rb.linearVelocity.magnitude;
        //clamps the velosity
        rb.linearVelocity = new Vector3(Mathf.Clamp(rb.linearVelocity.x, -0.5f, 0.5f), Mathf.Clamp(rb.linearVelocity.y, -0.5f, 0.5f), Mathf.Clamp(rb.linearVelocity.z, -0.5f, 0.5f));
        //roll the plane
        rb.AddTorque(-transform.forward * roll * rollSpeed);
        //tilt the plane up and down
        rb.AddTorque(transform.right * pitch * tiltSpeed);
        //rotate the plane left and right
        rb.AddTorque(transform.up * yaw * 0.02f);
        //slow turn so it stops when inactive
        rb.angularVelocity = new Vector3(Mathf.Lerp(rb.angularVelocity.x, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.y, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.z, 0, 2 * Time.fixedDeltaTime));
        rb.angularVelocity = new Vector3(Mathf.Clamp(rb.angularVelocity.x, -4, 4), Mathf.Clamp(rb.angularVelocity.y, -4, 4), Mathf.Clamp(rb.angularVelocity.z, -4, 4));
    }
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag != "touchable")
        {
            SceneManager.LoadScene(0);
        }
    }
}
