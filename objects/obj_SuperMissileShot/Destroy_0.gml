/// @description Explode
event_inherited();
if(scr_WithinCamRange())
{
    if(instance_exists(obj_ScreenShaker))
	{
		obj_ScreenShaker.Shake(30);
	}
}