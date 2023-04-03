using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSwitcher : MonoBehaviour
{
    public Material[] materials;
    [SerializeField] private GameObject rover01;
    private bool rover01Active;
    private Renderer rend;
    private int index = 0;


    void Start()
    {
        rend = GetComponent<Renderer>();
        rend.material = materials[0];
        rover01Active = false;
        rover01.SetActive(false);
    }

    public void ChangeMaterialOnClick()
    {
        index++;
        if (index >= materials.Length)
        {
            index = 0;
        }
        rend.material = materials[index];

        if (index == 2)
        {
            rover01.SetActive(true);
        }
        else
        {
            rover01.SetActive(false);
        }

        Debug.Log("Materiaalin nro " + index);
    }

    public void ChangeMaterialToAerial()
    {
        index = 0;
        rend.material = materials[index];
        rover01.SetActive(false);
        Debug.Log("Materiaalin nro " + index);

    }

    public void ChangeMaterialToTemperature()
    {
        index = 1;
        rend.material = materials[index];
        rover01.SetActive(false);
        Debug.Log("Materiaalin nro " + index);

    }

    public void ChangeMaterialToMars()
    {
        index = 2;
        rend.material = materials[index];
        rover01.SetActive(true);
        Debug.Log("Materiaalin nro " + index);

    }

    //public void ToggleRover()
    //{
    //    if (rover01Active == false)
    //    {
    //        rover01.SetActive(true);
    //        rover01Active = true;
    //    }
    //    else
    //    {
    //        rover01.SetActive(false);
    //        rover01Active = false;
    //    }

    //}

}
