if(!global.gamePaused || instance_exists(obj_XRay))
{
	alpha = max(alpha - fadeRate, 0);
}
if(alpha <= 0)
{
	instance_destroy();
}