using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameObjectManager : MonoBehaviour
{
    [SerializeField] private GameObject marsRover01;

    public void RoverOn()
    {
        marsRover01.SetActive(true);
        Debug.Log("Rover p‰‰lle!");
    }

    public void RoverOff()
    {
        marsRover01.SetActive(false);
        Debug.Log("Rover pois :(");

    }
}
