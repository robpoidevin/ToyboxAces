using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;

public class Missle : MonoBehaviour
{
    public GameObject boom;
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
    
        
    
    
    IEnumerator EnableCollider()
    {
        yield return new WaitForSeconds(1.0f);
        collider.enabled = true;
    }
}