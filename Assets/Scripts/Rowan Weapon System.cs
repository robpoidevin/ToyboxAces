using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using TMPro;

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
    [Header("Gun")]
    public GameObject ammoHUD;
    float ammo;
    public float maxAmmo;
    public float gunReloadTime; //these are both floats because of division performed later than needs floats
    public TMP_Text ammoUI;
    public TMP_Text ammoShadow;
    public Animator ammoAnimator;
    public Animator ammoFillAnimator;
    [Header("Missile")]
    public GameObject missileHUD;
    public float missileCooldown;
    public Animator missileAnimator;
    public Animator missileFillAnimator;
    bool canMissile = true;
    private void Start()
    {
        ammo = maxAmmo;
        ammoUI.text = $"{ammo}/{maxAmmo}";
        ammoShadow.text = $"{ammo}/{maxAmmo}";
        ammoFillAnimator.SetBool("isReloading", false);
        ammoAnimator.speed = 1/gunReloadTime;
        missileAnimator.SetBool("isReloading", false);
        missileAnimator.speed = 1/missileCooldown;
        ammoAnimator.enabled = false;
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
                Debug.Log(ammo / maxAmmo);
                ammoUI.text = $"{ammo}/{maxAmmo}";
                ammoShadow.text = $"{ammo}/{maxAmmo}";
                if (ammo == 0) StartCoroutine(Reload()); else StartCoroutine(Delay());
                fireLeft = !fireLeft; //inverts bool
            }
        }
        
        if (Input.GetKeyDown(KeyCode.K) && canMissile) 
        {
            Instantiate(missile, transform.position + missilePos, transform.rotation * Quaternion.Euler(90, 0, 0));
            canMissile = false;
            StartCoroutine(MissileCooldown());
        }
    }

    IEnumerator Delay()
    {
        yield return new WaitForSeconds(bulletDelay);
        canFire = true;
    }

    IEnumerator Reload()
    {
        ammoFillAnimator.SetBool("isReloading", true);
        ammoUI.text = $"RELOAD";
        ammoShadow.text = $"RELOAD";
        ammoAnimator.enabled = true;
        ammoAnimator.SetTrigger("startReloading");
        yield return new WaitForSeconds(gunReloadTime);
        ammo = maxAmmo;
        canFire = true;
        ammoUI.text = $"{ammo}/{maxAmmo}";
        ammoShadow.text = $"{ammo}/{maxAmmo}";
        ammoFillAnimator.SetBool("isReloading", false);
        ammoAnimator.enabled = false;
    }
    IEnumerator MissileCooldown()
    {
        missileAnimator.SetBool("isReloading", true);
        yield return new WaitForSeconds(missileCooldown);
        canMissile = true;
        missileAnimator.SetBool("isReloading", false);
        missileFillAnimator.SetTrigger("doneReloading");
    }
}
