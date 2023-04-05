using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonActivateDeactivate : MonoBehaviour
{
    public GameObject gameObjectToToggle;

    public void ToggleGameObject()
    {
        gameObjectToToggle.SetActive(!gameObjectToToggle.activeSelf);
    }
}
