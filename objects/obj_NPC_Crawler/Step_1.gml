/// @description Initialize

if(!initialize)
{
	moveDir *= sign(image_xscale)*sign(image_yscale);
	rotation = image_angle;
	rotation2 = rotation;
	image_angle = 0;
	
	initialize = true;
}