using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Microsoft.MixedReality.Toolkit.Input;

public class HandTouchTest : MonoBehaviour, IMixedRealityTouchHandler
{
    void IMixedRealityTouchHandler.OnTouchStarted(HandTrackingInputEventData eventData)
    {
        Debug.Log("touch started");
    }

    void IMixedRealityTouchHandler.OnTouchCompleted(HandTrackingInputEventData eventData)
    {
        Debug.Log("touch completed");
    }

    public void OnTouchUpdated(HandTrackingInputEventData eventData)
    {
        /// Do nothing
    }
}
