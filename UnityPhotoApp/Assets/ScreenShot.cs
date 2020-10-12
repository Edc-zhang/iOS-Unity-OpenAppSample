using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class ScreenShot : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void OnClick()
    {
        StartCoroutine(OnScreenShot());
    }

    public IEnumerator OnScreenShot()
    {
        Rect rect = new Rect(0.0f, 0.0f, (float)Screen.width, (float)Screen.height);
        Texture2D screenShotTex = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);

        yield return new WaitForEndOfFrame();

        screenShotTex.ReadPixels(rect, 0, 0);
        screenShotTex.Apply();

        byte[] bytes = screenShotTex.EncodeToJPG();
        string imgBase64 = Convert.ToBase64String(bytes);

        Application.OpenURL("mainapp://query?" + imgBase64);
    }
}