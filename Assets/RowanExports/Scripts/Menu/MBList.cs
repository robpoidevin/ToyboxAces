using UnityEngine;
using System.Collections.Generic;

public class MBList : MenuButton
{
    [Header("List")]
    public List<Object> options = new();
    public int currentSelection;

    public override void OnInteract()
    {
        currentSelection++;
        if (currentSelection >= options.Count)
        {
            currentSelection = 0;
        }
    }
}
