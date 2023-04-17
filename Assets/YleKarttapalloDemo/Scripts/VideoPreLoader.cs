using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class VideoPreLoader : MonoBehaviour
{
    public VideoPlayer videoPlayer; // Reference to the VideoPlayer component
    public GameObject associatedGameObject; // Reference to the associated GameObject that should be enabled after video loading

    void Start()
    {
        // Disable the associated GameObject initially
        associatedGameObject.SetActive(false);

        // Start loading the video
        videoPlayer.Prepare();

        // Add a callback to detect when the video loading is complete
        videoPlayer.prepareCompleted += OnVideoPrepared;
    }

    void OnVideoPrepared(VideoPlayer source)
    {
        // Enable the associated GameObject when video loading is complete
        associatedGameObject.SetActive(true);

        // Play the video
        videoPlayer.Play();

        // Remove the callback to avoid repeated calls
        videoPlayer.prepareCompleted -= OnVideoPrepared;
    }
}
