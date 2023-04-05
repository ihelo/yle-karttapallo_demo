using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class AloitaDemoScript : MonoBehaviour
{

    //public GameObject Demo;
    public GameObject Button;

    public GameObject[] objectsToScaleIn; // An array of game objects to scale in
    public float scaleInDuration = 1.0f; // The duration of the scale-in animation
    public Vector3 finalScale = new Vector3(1, 1, 1); // The final scale for the game objects

    private Vector3[] initialScales; // An array of initial scales for the game objects


    void Start()
    {

        initialScales = new Vector3[objectsToScaleIn.Length]; // Create a new array of initial scales for the game objects

        for (int i = 0; i < objectsToScaleIn.Length; i++)
        {
            initialScales[i] = objectsToScaleIn[i].transform.localScale; // Get the initial scale for each game object
        }

    }

   
    void Update()
    {
        
    }

    public void whenButtonIsClicked()
    {
        //Demo.SetActive(true);
        //Demo.transform.localScale(0, 0, 0);
       // Button.SetActive(false);
       
    }

    public void OnButtonClick()
    {
        StartCoroutine(ScaleInCoroutine()); // Start the coroutine to scale in the objects

        Button.SetActive(false);

    }


    IEnumerator ScaleInCoroutine()
    {
        float currentTime = 0.0f; // The current time
        while (currentTime < scaleInDuration)
        {
            float t = currentTime / scaleInDuration; // Calculate the lerp time
            for (int i = 0; i < objectsToScaleIn.Length; i++)
            {
                Vector3 initialScale = initialScales[i];
                Vector3 newScale = Vector3.Lerp(initialScale, finalScale, t); // Calculate the new scale for each game object
                objectsToScaleIn[i].transform.localScale = newScale;
            }
            currentTime += Time.deltaTime; // Increment the current time
            yield return null; // Wait for the next frame
        }
    }
}
