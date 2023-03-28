using UnityEngine;
using Microsoft.MixedReality.Toolkit.Input;

public class SpinObject : MonoBehaviour, IMixedRealityPointerHandler
{
    public float spinSpeed = 10f; // Speed of the spin in degrees per second

    private bool isBeingGazedAt = false;

    void Update()
    {
        if (isBeingGazedAt)
        {
            // Rotate the object on the Y-axis by the spin speed
            transform.Rotate(Vector3.up, spinSpeed * Time.deltaTime);
        }
    }

    public void OnPointerDown(MixedRealityPointerEventData eventData)
    {
        // Not used in this script
    }

    public void OnPointerDragged(MixedRealityPointerEventData eventData)
    {
        // Not used in this script
    }

    public void OnPointerUp(MixedRealityPointerEventData eventData)
    {
        // Not used in this script
    }

    public void OnPointerClicked(MixedRealityPointerEventData eventData)
    {
        // Toggle the gaze state when the object is clicked
        isBeingGazedAt = !isBeingGazedAt;
    }
}