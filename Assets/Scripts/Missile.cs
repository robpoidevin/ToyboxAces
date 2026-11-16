using UnityEngine;
using System.Collections;

//Made By Liam
public class Missile : MonoBehaviour
{
    public GameObject boom;     // Prefab for missile
    CapsuleCollider collider;
    Rigidbody rb;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        collider = GetComponent<CapsuleCollider>();
        rb = GetComponent<Rigidbody>();
        StartCoroutine(EnableCollider());
    }

    // Update is called once per frame
    void Update()
    {
        rb.linearVelocity = transform.up * 3f;
    }

    void OnCollisionEnter(Collision collision)
    {
        Instantiate(boom, transform.position, Quaternion.identity);
        Destroy(gameObject);
    }
    
    // Activates the hitbox a small time after launch so you can't accidentally shoot yourself
    IEnumerator EnableCollider()
    {
        yield return new WaitForSeconds(1.0f);
        collider.enabled = true;
    }
}