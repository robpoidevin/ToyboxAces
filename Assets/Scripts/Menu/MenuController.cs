using System.Collections.Generic;
using UnityEngine;

public class MenuController : MonoBehaviour
{
    public GameObject activeMenu;
    public AudioSource backgroundAudio;

    public List<KeyCode> increaseVert;
    public List<KeyCode> increaseHor;
    public List<KeyCode> decreaseVert;
    public List<KeyCode> decreaseHor;
    public List<KeyCode> confirmButtons;

    private MenuDefinition activeMenuDefinitions;
    public int activeButton = 0;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public void Start()
    {
        UpdateActiveMenuDefinition();
    }
    public void Update()
    {
        Debug.Log(activeButton);
        if (activeMenu != null)
        {
            switch (activeMenuDefinitions.GetMenuType())
            {
                case menuType.HORIZONTAL:
                    MenuInput(increaseHor, decreaseHor);
                    break;
                case menuType.VERTICAL:
                    MenuInput(increaseVert, decreaseVert);
                    break;
            }
        }
        
    }
    private void MenuInput(List<KeyCode> increase, List<KeyCode> decrease)
    {
        int newActive = activeButton;
        for (int i = 0; i < increase.Count; i++)
        {
            if (Input.GetKeyDown(increase[i]))
            {
                newActive = SwitchCurrentButton(1);
            }
        }
        for (int i = 0; i < decrease.Count; i++)
        {
            if (Input.GetKeyDown(decrease[i]))
            {
                newActive = SwitchCurrentButton(-1);
            }
        }
        for (int i = 0; i < confirmButtons.Count; i++)
        {
            if (Input.GetKeyDown(confirmButtons[i]))
            {
                ClickCurrentButton();
            }
        }
        activeButton = newActive;
    }
    private int SwitchCurrentButton(int increment)
    {
        if (!activeMenuDefinitions.GetButtonDefinitions()[activeButton].GetDisableControls())
        {
            int newActive = Utility.WrapAround(activeMenuDefinitions.GetButtonCount(), activeButton, increment);
            activeMenuDefinitions.GetButtonDefinitions()[activeButton].SwappedOff();
            activeMenuDefinitions.GetButtonDefinitions()[newActive].SwappedTo();
            return newActive;
        }
        else
        {
            return activeButton;
        }
    }
    private void ClickCurrentButton()
    {
        if (!activeMenuDefinitions.GetButtonDefinitions()[activeButton].GetDisableControls())
        {
            StartCoroutine(activeMenuDefinitions.GetButtonDefinitions()[activeButton].ClickButton());
        }
    }
    public void UpdateActiveMenuDefinition()
    {
        activeMenuDefinitions =  activeMenu.GetComponent<MenuDefinition>();

        /*if (activeMenuDefinitions.menuMusic != null)
        {
            backgroundAudio.clip = activeMenuDefinitions.menuMusic;
            backgroundAudio.Play();
        }
        else if (!activeMenuDefinitions.continuePrevMusic)
        { 
            backgroundAudio.Stop();
        }*/
    }
    public void SetActiveMenu(GameObject menu)
    {
        activeMenu = menu;
        activeButton = 0;
        if (activeMenu != null)
        {

            UpdateActiveMenuDefinition();
        }
        for (int i = 0; i < activeMenuDefinitions.GetButtonDefinitions().Count; i++)
        {

            activeMenuDefinitions.GetButtonDefinitions()[i].SwappedOff();
        }
        activeMenuDefinitions.GetButtonDefinitions()[0].SwappedTo();
    }
}
