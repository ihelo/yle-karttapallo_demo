using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIHandlesOnOff : MonoBehaviour
{
    [SerializeField] private GameObject handle01Article;
    [SerializeField] private GameObject handle02Footer;
    [SerializeField] private GameObject handle03Video;
    [SerializeField] private GameObject handle04Master;
    [Space]
    [SerializeField] private GameObject easterEggLol;
    private bool handlesActive;

    // Start is called before the first frame update
    void Start()
    {
        handlesActive = false;
    }

    public void ToggleHandles()
    {
        if (handlesActive == false)
        {
            handle01Article.SetActive(true);
            handle02Footer.SetActive(true);
            handle03Video.SetActive(true);
            handle04Master.SetActive(true);
            easterEggLol.SetActive(true);
            handlesActive = true;
            Debug.Log("Handlet p‰‰lle!");
        }
        else
        {
            handle01Article.SetActive(false);
            handle02Footer.SetActive(false);
            handle03Video.SetActive(false);
            handle04Master.SetActive(false);
            easterEggLol.SetActive(false);
            handlesActive = false;
            Debug.Log("Handlet pois!");
        }
    }


    // Update is called once per frame
    void Update()
    {
        
    }
}
