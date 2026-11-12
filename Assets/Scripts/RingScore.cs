using UnityEngine;

public class RingScore : MonoBehaviour
{
    [SerializeField] BoxCollider trigger;
    public bool triggered = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Triggered();
        }
    }

    void Triggered()
    {
        triggered = true;
        trigger.enabled = false;
    }
}
