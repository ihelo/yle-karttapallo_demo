using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.Input;

public class AudioController : MonoBehaviour
{
    public AudioSource audioPlayerSource;

    private void Start()
    {
        audioPlayerSource = GetComponent<AudioSource>();
    }

    public void PlayAudio()
    {
        Debug.Log("Play Painettu");
        audioPlayerSource.Play();
    }

    public void PauseAudio()
    {
        audioPlayerSource.Pause();
    }

    public void StopAudio()
    {
        audioPlayerSource.Stop();
    }

}
