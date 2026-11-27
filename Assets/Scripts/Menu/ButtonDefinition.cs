using System.Collections;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Button))]
public class ButtonDefinition : MonoBehaviour
{
    public bool animated = false;
    public Color unselectedTint = Color.gray;
    public Color selectedTint = Color.white;
    public bool selected = false;
    private Button Button;
    private Image Image;
    private bool disableControls = false;
    private Animator animator;

    public AudioClip swapToSFX;
    public AudioClip confirmSFX;
    public float confirmTime;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        Button = GetComponent<Button>();
        Image = GetComponent<Image>();
        animated = TryGetComponent<Animator>(out animator);

        if (!animated)
        {
            if (selected)
            {
                Image.color = selectedTint;
            }
            else
            {
                Image.color = unselectedTint;
            }
        }
        
    }
    public void SwappedTo()
    {
        selected = true;

        if (swapToSFX != null)
        {
            AudioSource.PlayClipAtPoint(swapToSFX, Vector3.zero);
        }
        if (animated)
        {
            animator.SetBool("Selected", selected);
        }
        else
        {
            Image.color = selectedTint;
        }
    }

    public void SwappedOff()
    {
        selected = false;
        if (animated)
        {
            animator.SetBool("Selected", selected);
        }
        else
        {
            Image.color = unselectedTint;
        }
    }
    public void SetSelected()
    {
        selected = true;
    }
    public void SetUnselected()
    {
        selected = false;
    }
    public IEnumerator ClickButton()
    {
        if (!disableControls)
        {
            disableControls = true;

            if (confirmSFX != null)
            {
                AudioSource.PlayClipAtPoint(confirmSFX, Vector3.zero);
            }

            yield return new WaitForSeconds(confirmTime);

            Button.onClick.Invoke();
            disableControls = false;
        }
    }
    public bool GetDisableControls()
    {
        return disableControls;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
