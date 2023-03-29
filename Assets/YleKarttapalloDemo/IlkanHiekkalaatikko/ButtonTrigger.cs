using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ButtonTrigger : MonoBehaviour
{
    [SerializeField] private GameObject uutisetObject;
    [SerializeField] private GameObject viestitObject;
    [SerializeField] private GameObject kissavideoObject;

    private bool uutisetActive = false;
    private bool viestitActive = true;
    private bool kissavideoActive = true;
    public Animator cubeAnimation;


    public void ToggleUutiset()
    {
        if (uutisetActive == false) {
            uutisetObject.SetActive(true);
            Debug.Log("Uutiset ON");
            uutisetActive = true;
        }

        else
        {
            uutisetObject.SetActive(false);
            Debug.Log("Uutiset OFF");
            uutisetActive = false;
        }

    }

    public void ToggleViestit()
    {
        cubeAnimation.SetTrigger("SpinTrigger");
    }

    public void ToggleKissavideo()
    {
        if (kissavideoActive == false)
        {
            kissavideoObject.SetActive(true);
            Debug.Log("kissavideo ON");
            kissavideoActive = true;
        }

        else
        {
            kissavideoObject.SetActive(false);
            Debug.Log("kissavideo OFF");
            kissavideoActive = false;
        }
    }
}