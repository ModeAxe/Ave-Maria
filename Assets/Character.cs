using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Character : MonoBehaviour
{

    // Start is called before the first frame update
    public float speed;
    public Animator animator;
    public Rigidbody rb;
    
    public float ForceYMin;
    public float ForceYMax;
    
    public float ForceXMin;
    public float ForceXMax;

    public float ForceZMax;
    public float ForceZMin;


    private bool running;
    void Start()
    {
        running = true;
        
    }

    // Update is called once per frame
    void Update()
    {
        if(running)
            transform.position = new Vector3 (transform.position.x, transform.position.y, transform.position.z + Time.deltaTime * -speed);
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag.Equals("trigger"))
        {
            animator.enabled = false;
            running = false;
            rb.AddForce(new Vector3(Random.Range(ForceXMin, ForceXMax), Random.Range(ForceYMin, ForceYMax), Random.Range(-ForceZMin, -ForceZMax)));
        }
    }
    void fly()
    {

    }
}
