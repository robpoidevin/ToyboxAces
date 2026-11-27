using NUnit.Framework;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public enum menuType
{
    HORIZONTAL, VERTICAL
}

public class MenuDefinition : MonoBehaviour
{
    public menuType menuType = menuType.HORIZONTAL;
    public AudioClip menuMusic;
    public bool continuePrevMusic = false;
    public List<GameObject> menuButtonObjects = new List<GameObject>();

    private List<ButtonDefinition> menuButtonDefinitions = new List<ButtonDefinition>();
    private List<Button> menuButtons = new List<Button>();
    private List<Animator> menuAnimators = new List<Animator>();
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public void Awake()
    {
        for (int i = 0; i < menuButtonObjects.Count; i++)
        {
            menuButtonDefinitions.Add(menuButtonObjects[i].GetComponent<ButtonDefinition>());
            menuButtons.Add(menuButtonObjects[i].GetComponent<Button>());
            Animator temp = null;
            menuButtonObjects[i].TryGetComponent(out temp);
            menuAnimators.Add(temp);
        }
    }

    // Update is called once per frame
    public menuType GetMenuType()
    {
        return menuType;
    }
    public int GetButtonCount()
    {
        return menuButtonObjects.Count;
    }
    public List<ButtonDefinition> GetButtonDefinitions()
    {
        return menuButtonDefinitions;
    }
    public List<Button> GetButtons()
    {
        return menuButtons;
    }
    public List<Animator> GetAnimators()
    {
        return menuAnimators;
    }
}
