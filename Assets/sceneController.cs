using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sceneController : MonoBehaviour
{
    // Start is called before the first frame update\
    public GameObject[] cameras;
    private int currentCam;
	void Start()
	{
		currentCam = 0;
		setCam(currentCam);
	}

	// Update is called once per frame
	void Update()
	{
        if (Input.GetKeyDown(KeyCode.C))
        {
			toggleCam();
        }

	}

	public void setCam(int idx)
	{
		for (int i = 0; i < cameras.Length; i++)
		{
			if (i == idx)
			{
				cameras[i].SetActive(true);
			}
			else
			{
				cameras[i].SetActive(false);
			}
		}
	}

	public void toggleCam()
	{
		currentCam++;
		if (currentCam > cameras.Length - 1)
			currentCam = 0;
		setCam(currentCam);
	}
}
