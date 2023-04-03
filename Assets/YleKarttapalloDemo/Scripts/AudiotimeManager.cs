using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudiotimeManager : MonoBehaviour
{
    AudioSource audioSource;
    private bool audioPlay;

    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {

        if (audioSource.isPlaying)
        {
            audioPlay = true;
            Debug.Log("Audio Time: " + audioSource.time.ToString());
        }

        else if (audioPlay)
        {
            audioPlay = false;
            Debug.Log("Stopped");
        }

    }
}
