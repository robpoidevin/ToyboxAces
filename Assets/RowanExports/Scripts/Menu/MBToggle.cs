using UnityEngine;

public class MBToggle : MenuButton
{
    [Header("Toggle")]
    public bool isTrue;

    public override void OnInteract()
    {
        isTrue = !isTrue;
    }
}
