/// @description Initialize
event_inherited();

dir = sign(image_xscale);
mSpeed = 1;

function OnXCollision(fVX)
{
	dir = -sign(fVX);
	velX = 0;
	fVelX = 0;
}