using UnityEngine;

public class Utility : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public static int WrapAround(int max, int current, int increment, int min = 0)
    {
        int temp = current + increment;
        if (temp >= max)
        {
            temp = min;
        }
        else if (temp < min)
        {
            temp = max - 1; 
        }
        return temp;
    }
}
