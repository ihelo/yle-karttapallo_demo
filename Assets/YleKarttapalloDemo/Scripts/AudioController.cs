using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.Input;

public class AudioController : MonoBehaviour
{
    AudioSource audioSource;
    bool audioPlaying;
    public float secondSkipBackward;
    public float secondSkipForward;

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
            audioPlaying = true;
            Debug.Log("Audio Time: " + audioSource.time.ToString());
        }
        else if (audioPlaying)
        {
            audioPlaying = false;
            Debug.Log("Audio Stopped");
        }

        
    }

    public void AddSeconds()
    {
        // Check for input to skip 10 seconds
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            audioSource.time += secondSkipForward;
        }
    }

    public void RemoveSeconds()
    {
        // Check for input to skip 10 seconds
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            audioSource.time += secondSkipBackward;
        }
    }

}
