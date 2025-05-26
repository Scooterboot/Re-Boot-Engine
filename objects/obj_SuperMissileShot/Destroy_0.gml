/// @description Explode
event_inherited();
if(outsideCam <= 1)
{
    if(instance_exists(obj_ScreenShaker))
	{
		obj_ScreenShaker.Shake(21);
	}
}