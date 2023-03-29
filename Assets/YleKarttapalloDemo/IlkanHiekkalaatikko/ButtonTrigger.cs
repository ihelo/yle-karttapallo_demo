using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ButtonTrigger : MonoBehaviour
{
    [SerializeField] private GameObject uutisetObject;
    [SerializeField] private GameObject viestitObject;

    private bool uutisetActive = false;
    private bool viestitActive = false;


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
        if (viestitActive == false)
        {
            viestitObject.SetActive(true);
            Debug.Log("viestit ON");
            viestitActive = true;
        }

        else
        {
            viestitObject.SetActive(false);
            Debug.Log("viestit OFF");
            viestitActive = false;
        }
    }
}