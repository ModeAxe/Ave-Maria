using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sceneController : MonoBehaviour
{
    // Start is called before the first frame update\
    public GameObject[] cameras;
	public GameObject man;
    private int currentCam;
	private float currentTime;
	void Start()
	{
		currentCam = 0;
		setCam(currentCam);
		spawnMan();
	}

	// Update is called once per frame
	void Update()
	{
        if (Input.GetKeyDown(KeyCode.C))
        {
			toggleCam();
        }

		if (Input.GetKeyDown(KeyCode.Space))
		{
			spawnMan();
		}

		currentTime += Time.deltaTime;

		float wait = UnityEngine.Random.Range(4, 10);

		if (currentTime >= wait)
		{
			currentTime = currentTime - wait;
			spawnMan();
		}

	}

    private void spawnMan()
    {
		Instantiate(man, new Vector3(UnityEngine.Random.Range(17.75f, -19.83f), 14.968f, UnityEngine.Random.Range(2.96f, -1.41f)), transform.rotation * Quaternion.Euler(0f, 180f, 0f));
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
