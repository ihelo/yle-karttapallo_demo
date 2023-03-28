using Microsoft.MixedReality.Toolkit.Input;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwipeToSpin : MonoBehaviour, IMixedRealityGestureHandler<Vector2>
{
    public float spinSpeed = 10f; // Speed of the spin in degrees per second

    private bool isSwiping = false;

    void Update()
    {
        if (isSwiping)
        {
            // Rotate the object on the Y-axis by the spin speed
            transform.Rotate(Vector3.up, spinSpeed * Time.deltaTime);
        }
    }

    public void OnGestureStarted(InputEventData eventData)
    {
        // Check if the input source is a hand
        if (eventData.InputSource.SourceType == InputSourceType.Hand)
        {
            isSwiping = true;
        }
    }

    public void OnGestureUpdated(InputEventData<Vector2> eventData)
    {
        // Not used in this script
    }

    public void OnGestureCompleted(InputEventData eventData)
    {
        // Check if the input source is a hand
        if (eventData.InputSource.SourceType == InputSourceType.Hand)
        {
            isSwiping = false;
        }
    }

    public void OnGestureCanceled(InputEventData eventData)
    {
        // Check if the input source is a hand
        if (eventData.InputSource.SourceType == InputSourceType.Hand)
        {
            isSwiping = false;
        }
    }

    public void OnGestureCompleted(InputEventData<Vector2> eventData)
    {
        throw new System.NotImplementedException();
    }

    public void OnGestureUpdated(InputEventData eventData)
    {
        throw new System.NotImplementedException();
    }
}
