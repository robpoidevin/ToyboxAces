using UnityEngine;
using UnityEngine.SceneManagement;

public class ScoreManager : MonoBehaviour
{
    [SerializeField] GameObject ring1;
    [SerializeField] GameObject ring2;
    [SerializeField] GameObject ring3;

    RingScore ringScore1;
    RingScore ringScore2;
    RingScore ringScore3;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        ringScore1 = ring1.GetComponent<RingScore>();
        ringScore2 = ring2.GetComponent<RingScore>();
        ringScore3 = ring3.GetComponent<RingScore>();
    }

    // Update is called once per frame
    void Update()
    {
        if (ringScore1.triggered && ringScore2.triggered && ringScore3.triggered)
        {
            SceneManager.LoadScene("YOU WIN!");
        }
    }
}
