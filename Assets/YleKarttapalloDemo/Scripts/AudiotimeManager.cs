using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudiotimeManager : MonoBehaviour
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
        audioSource.time += secondSkipForward;
    }

    public void RemoveSeconds()
    {
        audioSource.time -= secondSkipBackward;
    }

    public void StopAudio()
    {
        audioSource.Stop();
        audioSource.time = 0f;
    }
}
