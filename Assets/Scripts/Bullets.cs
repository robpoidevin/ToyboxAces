using UnityEngine;
using System.Collections;

public class Bullets : MonoBehaviour
{
    
    public GameObject bulletPrefab;
    private float speed;
    CapsuleCollider collider;
    Rigidbody rb;
    
    void Start()
    {
        collider = GetComponent<CapsuleCollider>();
        rb = GetComponent<Rigidbody>();
        StartCoroutine(EnableCollider());
    }

    void Update()
    {
        rb.linearVelocity = transform.up * 3f;
    }

    void OnCollisionEnter(Collision collision)
    {
        //Instantiate(spark, transform.position, Quaternion.identity);      If we want contact particles we add it here
        Destroy(gameObject);
    }
    
    IEnumerator EnableCollider()
    {
        yield return new WaitForSeconds(1.0f);
        collider.enabled = true;
    }
}
