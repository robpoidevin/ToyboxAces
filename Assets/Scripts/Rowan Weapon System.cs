using UnityEngine;
using System.Collections;
using UnityEngine.UI;

// Made By Liam
public class RowanWeaponSystem : MonoBehaviour
{
    public GameObject missile;
    public GameObject bullet;
    public ParticleSystem barrelLeft;
    public ParticleSystem barrelRight;
    public float bulletDelay;
    bool canFire = true;
    bool fireLeft = true;
    Vector3 missilePos = new Vector3(0, -0.02f, 0);
    Vector3 bulletPosL = new Vector3(-0.06f, -0.008f, 0.05f);
    Vector3 bulletPosR = new Vector3(0.06f, -0.008f, 0.05f);

    public GameObject ammoHUD;
    float ammo;
    public float maxAmmo;
    public float gunReloadTime; //these are both floats because of division performed later than needs floats

    private void Start()
    {
        ammo = maxAmmo;
    }
    void Update()
    {
        if (canFire)
        {
            if (Input.GetMouseButton(0))
            {
                /*
                if (fireLeft)
                {
                    barrelLeft.Play();
                    Instantiate(bullet, transform.position + bulletPosL, transform.rotation * Quaternion.Euler(90, 0, 0));
                    canFire = false;
                    StartCoroutine(Delay());
                    fireLeft = false;
                }

                else if (!fireLeft)
                {
                    barrelRight.Play();
                    Instantiate(bullet, transform.position + bulletPosR, transform.rotation * Quaternion.Euler(90, 0, 0));
                    canFire = false;
                    StartCoroutine(Delay());
                    fireLeft = true;
                }
                */
                // Rowan Has A Suggestion !!
                if (fireLeft)
                {
                    barrelLeft.Play();
                    Instantiate(bullet, transform.position + bulletPosL, transform.rotation * Quaternion.Euler(90, 0, 0));
                }
                else
                {

                    barrelRight.Play();
                    Instantiate(bullet, transform.position + bulletPosR, transform.rotation * Quaternion.Euler(90, 0, 0));
                }
                ammo--;
                canFire = false;
                ammoHUD.GetComponent<Slider>().value = ammo / maxAmmo;
                if (ammo == 0) StartCoroutine(Reload()); else StartCoroutine(Delay());
                fireLeft = !fireLeft; //inverts bool
            }
        }
        
        if (Input.GetKeyDown(KeyCode.K)) 
        {
            Instantiate(missile, transform.position + missilePos, transform.rotation * Quaternion.Euler(90, 0, 0));
        }
    }

    IEnumerator Delay()
    {
        yield return new WaitForSeconds(bulletDelay);
        canFire = true;
    }

    IEnumerator Reload()
    {
        yield return new WaitForSeconds(gunReloadTime);
        ammo = maxAmmo;
        ammoHUD.GetComponent<Slider>().value = ammo / maxAmmo;
        canFire = true;
    }
}
