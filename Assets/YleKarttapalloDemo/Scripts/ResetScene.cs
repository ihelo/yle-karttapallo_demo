using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetScene : MonoBehaviour
{
    public float resetTimer;
    // [Range(0f, 5f)]
    public float resetTimerLimit;
    public bool resetTimerOn;

    // Start is called before the first frame update
    void Start()
    {
        resetTimer = 0f;
        resetTimerOn = false;
        // Do nothing for now :)
    }

    public void StartResetTimer()
    {
        Debug.Log("Reset pushed!");
        resetTimerOn = true;

        if (resetTimerOn == true)
        {
            resetTimer = resetTimer + Time.deltaTime;
            if (resetTimer >= resetTimerLimit)
            {
                Debug.Log("Timer hit the limit!");
                resetTimerOn = false;
                resetTimer = 0f;
              //  Reset(); 
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
