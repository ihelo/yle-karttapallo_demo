using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class UIFunctions : MonoBehaviour
{
    [SerializeField] private GameObject globe01;
    [SerializeField] private GameObject globe02;
    [SerializeField] private GameObject menu01;
    [SerializeField] private GameObject menu02;
    [SerializeField] private GameObject article01;
    [SerializeField] private GameObject article02;



    private bool globe01Active = true;
    private bool globe02Active = true;
    private bool menu01Active = false;
    private bool menu02Active = false;
    private bool article01Active = true;
    private bool article02Active = true;


    public void ToggleArticle()
    {
        KillSubMenus();
        /*
         Jos globe 01 p‰‰ll‰
            Laita globe 01 pois
            Laita globe 02 p‰‰lle
            p‰ivit‰ muuttujat
        Muuten
            Laita Globe 01 p‰‰lle
            Laita Globe 02 pois
            p‰ivit‰ muuttujat

       Jos article 01 p‰‰ll‰
            Laita article 01 pois
            Laita article 02 p‰‰lle
            p‰ivit‰ muuttujat
        Muuten
            Laita article 01 p‰‰lle
            Laita article 02 pois
            p‰ivit‰ muuttujat
         */

        if (globe01Active == true)
        {
            globe01.SetActive(false);
            globe02.SetActive(true);
            globe01Active = false;
            globe02Active = true;

        }
        else
        {
            globe01.SetActive(true);
            globe02.SetActive(false);
            globe01Active = true;
            globe02Active = false;
        }

        if (article01Active == true)
        {
            article01.SetActive(false);
            article02.SetActive(true);
            article01Active = false;
            article02Active = true;

        }
        else
        {
            article01.SetActive(true);
            article02.SetActive(false);
            article01Active = true;
            article02Active = false;
        }

    }
    public void ToggleGlobe()
    {
        if (globe01Active == false)
        {
            globe01.SetActive(true);
            globe01Active = true;
            Debug.Log("globe 01 p‰‰lle");
        }
        else
        {
            globe01.SetActive(false);
            globe01Active = false;
            Debug.Log("globe 01 pois");
        }

        KillSubMenus();

    }

    public void ToggleMenu01()
    {
        if (menu01Active == false)
        {
            menu01.SetActive(true);
            menu01Active = true;
            Debug.Log("Menu 01 p‰‰lle");
        }
        else
        {
            menu01.SetActive(false);
            menu01Active = false;
            Debug.Log("Menu 01 pois");
        }
  
        if (menu02Active == true)
        {
            menu02.SetActive(false);
            menu02Active = false;
            Debug.Log("Menu 02 pois p‰‰lt‰");
        }
    }

    public void ToggleMenu02()
    {
        if (menu02Active == false)
        {
            menu02.SetActive(true);
            menu02Active = true;
            Debug.Log("Menu 02 p‰‰lle");
        }
        else
        {
            menu02.SetActive(false);
            menu02Active = false;
            Debug.Log("Menu 02 pois");
        }

        if (menu01Active == true)
        {
            menu01.SetActive(false);
            menu01Active = false;
            Debug.Log("Menu 01 pois p‰‰lt‰");
        }
    }

    public void KillSubMenus()
    {
        menu01.SetActive(false);
        menu01Active = false;
        menu02.SetActive(false);
        menu02Active = false;
    }



    // Start is called before the first frame update
    void Start()
    {
        KillSubMenus();
    }

    // Update is called once per frame



    void Update()
    {
        
    }
}
