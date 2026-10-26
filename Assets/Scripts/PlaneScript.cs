using UnityEngine;

public class PlaneScript : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    Rigidbody rb;
    [Header("Propeller")]
    public GameObject propeller;
    public float maxPropellerSpeed;
    public float propellerSpeed;
    [Header("Plane")]
    public float speedIncrement;
    public float maxSpeed;
    public float speed;
    public float turnSpeed;
    Vector3 turn = Vector3.zero;
    float pitch;
    float yaw;
    float roll;
    
    void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        //----------Propeller------------
        if (Input.GetKey(KeyCode.Space) && propellerSpeed != maxPropellerSpeed)
        {
            propellerSpeed += 1f * Time.deltaTime;
        }
        else if (!Input.GetKey(KeyCode.Space) && propellerSpeed > 0)
        {
            propellerSpeed -= 1f * Time.deltaTime;
        }
        else
        {
            Debug.Log("done or not working");
        }
        propeller.transform.Rotate(new Vector3(0, propellerSpeed, 0));
        //------------------------------
        Debug.Log(rb.linearVelocity);
        roll = Input.GetAxis("Horizontal");
        pitch = Input.GetAxis("Vertical");
        if (Input.GetKey(KeyCode.Space))
        {
            speed += speedIncrement;
        }
        else if (!Input.GetKey(KeyCode.Space))
        {
            speed -= speedIncrement;
        }
        speed = Mathf.Clamp(speed, 0f, 100);
        //transform.Rotate(new Vector3(0, 0, 0.1f));
    }
    private void FixedUpdate()
    {
        
        rb.AddForce((transform.forward + turn) * maxSpeed * speed);
        rb.linearVelocity = transform.forward * rb.linearVelocity.magnitude;
        rb.linearVelocity = new Vector3(Mathf.Clamp(rb.linearVelocity.x, -0.5f, 0.5f), Mathf.Clamp(rb.linearVelocity.y, -0.5f, 0.5f), Mathf.Clamp(rb.linearVelocity.z, -0.5f, 0.5f));
        rb.AddTorque(-transform.forward * roll * 0.03f);
        if (!Input.GetKey(KeyCode.Space))
        {
            rb.linearVelocity = new Vector3(Mathf.Lerp(rb.linearVelocity.x, 0, 2 * Time.fixedDeltaTime), rb.linearVelocity.y, rb.linearVelocity.z);
        }
        /*if (!Input.GetKey(KeyCode.A) && rb.angularVelocity.z > 0)
        {
            rb.angularVelocity = new Vector3(rb.angularVelocity.x, rb.angularVelocity.y, Mathf.Lerp(rb.angularVelocity.z, 0, 2 *Time.fixedDeltaTime));
        }
        if (!Input.GetKey(KeyCode.D) && rb.angularVelocity.z < 0)
        {
            rb.angularVelocity = new Vector3(rb.angularVelocity.x, rb.angularVelocity.y, Mathf.Lerp(rb.angularVelocity.z, 0, 2 * Time.fixedDeltaTime));
        }*/
        rb.angularVelocity = new Vector3(Mathf.Lerp(rb.angularVelocity.x, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.y, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.z, 0, 2 * Time.fixedDeltaTime));
        rb.AddTorque(transform.right * pitch * 0.0007f);
        if (!Input.GetKey(KeyCode.W) && rb.angularVelocity.x > 0)
        {
            rb.angularVelocity = new Vector3(Mathf.Lerp(rb.angularVelocity.x, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.y, 0, 2 * Time.fixedDeltaTime), rb.angularVelocity.z);
        }
        if (!Input.GetKey(KeyCode.S) && rb.angularVelocity.x < 0)
        {
            rb.angularVelocity = new Vector3(Mathf.Lerp(rb.angularVelocity.x, 0, 2 * Time.fixedDeltaTime), Mathf.Lerp(rb.angularVelocity.y, 0, 2 * Time.fixedDeltaTime), rb.angularVelocity.z);
        }
        rb.angularVelocity = new Vector3(Mathf.Clamp(rb.angularVelocity.x, -4, 4), Mathf.Clamp(rb.angularVelocity.y, -4, 4), Mathf.Clamp(rb.angularVelocity.z, -4, 4));
    }
}
