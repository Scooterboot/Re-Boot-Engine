/// @description Initialize

if(!initialize)
{
	moveDir *= sign(image_xscale)*sign(image_yscale);
	rotation = image_angle;
	rotation2 = rotation;
	
	initialize = true;
}