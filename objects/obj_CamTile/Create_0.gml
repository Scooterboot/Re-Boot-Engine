/// @description Initialize

active = true;

scrollList = ds_list_create();

enum CamTileFacing
{
	Down,
	Up,
	Right,
	Left
}

facing = CamTileFacing.Down;
if((angle_difference(image_angle,180) == 0 && image_yscale > 0) || 
	(angle_difference(image_angle,0) == 0 && image_yscale < 0))
{
	facing = CamTileFacing.Up;
}

if((angle_difference(image_angle,90) == 0 && image_yscale > 0) || 
	(angle_difference(image_angle,-90) == 0 && image_yscale < 0))
{
	facing = CamTileFacing.Right;
}

if((angle_difference(image_angle,-90) == 0 && image_yscale > 0) || 
	(angle_difference(image_angle,90) == 0 && image_yscale < 0))
{
	facing = CamTileFacing.Left;
}

