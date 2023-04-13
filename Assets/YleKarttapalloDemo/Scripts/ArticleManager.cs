using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ArticleManager : MonoBehaviour
{
    public ArticleData articleData;


    [Space(20)][Header("Prefab Setup")]
    public AudioSource audioPlayer;
    public SpriteRenderer spriteRenderer;
    public MeshRenderer planetMeshRenderer;


    public void SetData()
    {
        audioPlayer.clip = articleData.articleAudio;
        spriteRenderer.sprite = articleData.articlePicture;
        planetMeshRenderer.material = articleData.planetMaterial;
    }
}
