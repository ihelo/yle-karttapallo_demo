using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetScene : MonoBehaviour
{
    private float resetTimer;
    [Range(0f, 5f)]
    public float resetTimerLimit;
    private bool resetTimerOn;

    // Start is called before the first frame update
    void Start()
    {
        resetTimer = 0f;
        // resetTimerLimit = 3f;
        resetTimerOn = false;
    }

    public void StartResetTimer()
    {
        Debug.Log("Reset pushed!");
        resetTimerOn = true;
    }

    void Update()
    {
        if (resetTimerOn == true)
        {
            resetTimer = resetTimer + Time.deltaTime;
            if (resetTimer >= resetTimerLimit)
            {
                Debug.Log("Timer hit the limit!");
                resetTimerOn = false;
                resetTimer = 0f;
                Reset(); 
            }
        }

    }

    public void Reset()
    {
         // Get the current scene's name
        string currentSceneName = UnityEngine.SceneManagement.SceneManager.GetActiveScene().name;

        // Load the current scene again to reset it
        UnityEngine.SceneManagement.SceneManager.LoadScene(currentSceneName);

        Debug.Log("Scene has been reseted");

    }
}
