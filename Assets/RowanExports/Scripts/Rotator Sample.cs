using UnityEngine;

public class RotatorSample : MonoBehaviour
{
    public Vector3 axis;
    public float rotationSpeed;

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(axis * rotationSpeed);
    }
}
