/// @description Explode
event_inherited();
if(scr_WithinCamRange(-1,-1,96))
{
    if(instance_exists(obj_ScreenShaker))
	{
		obj_ScreenShaker.Shake(21);
	}
}