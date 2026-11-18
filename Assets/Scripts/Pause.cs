using UnityEngine;
using UnityEngine.UI;

public class Pause : MonoBehaviour
{
    public bool isPaused = false;
    public bool onPage1 = true;
    public bool normieOn = false;
    public GameObject pauseMenu;
    public GameObject page1;
    public GameObject page2;
    public GameObject normieToggle;
    public GameObject player;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        page2.SetActive(false);
        pauseMenu.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape) && !isPaused)
        {
            PauseGame();
        }
        else if (Input.GetKeyDown(KeyCode.Escape) && isPaused && onPage1)
        {
            UnpauseGame();
        }
        else if (Input.GetKeyDown(KeyCode.Escape) && isPaused && !onPage1)
        {
            ToPage1();
        }
    }
    public void PauseGame()
    {
        
        pauseMenu.SetActive(true);
        Time.timeScale = 0;
        isPaused = true;
        onPage1 = true;
        pauseMenu.SetActive(true);
    }
    public void UnpauseGame()
    {
        Time.timeScale = 1;
        isPaused = false;
        pauseMenu.SetActive(false);
    }
    public void Quit()
    {
        Application.Quit();
    }
    public void ToPage1()
    {
        page1.SetActive(true);
        page2.SetActive(false);
        onPage1 = true;
    }
    public void ToPage2()
    {
        page1.SetActive(false);
        page2.SetActive(true);
        onPage1 = false;
    }
    public void SwapNormie()
    {
        normieOn = !normieOn;
        if (normieOn)
        {
            normieToggle.GetComponent<Image>().color = Color.white;
        }
        else
        {
            normieToggle.GetComponent<Image>().color = Color.black;
        }
        player.GetComponent<PlaneScript>().isNormie = normieOn;
    }
}
