/// @description Initialize
event_inherited();

dir = sign(image_xscale);
mSpeed = 1;

function OnXCollision(fVX, isOOB = false)
{
	dir = -sign(fVX);
	velX = 0;
	fVelX = 0;
}

function CanMoveUpSlope_Bottom() { return false; }
function CanMoveDownSlope_Bottom() { return false; }