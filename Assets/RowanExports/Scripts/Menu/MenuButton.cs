using System;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

[RequireComponent(typeof(Button))]
[Serializable]
public class MenuButton : MonoBehaviour
{
    //toggles: isTrue, paired indicator, desc text
    //lists: selected option, option list, paired indicator, desc text
    //sliders: current value, paired indicator, desc text
    //submenu links: menu to go to, desc text
    [Header("Menu Button")]
    public string descText = "Currently unimplemented";
    public TMP_Text descDisplay;
    public GameObject indicator;

    public virtual void Update()
    {
        if (gameObject.GetComponent<Button>().IsHighlighted())
        {
            descDisplay.text = descText;
        }
    }
    public virtual void OnInteract() { }
}
