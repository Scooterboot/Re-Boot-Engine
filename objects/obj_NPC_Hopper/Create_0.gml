/// @description Initialize
event_inherited();

deathType = 1;

jumpSpeedX[0] = 3;
jumpSpeedY[0] = 6;

jumpSpeedX[1] = 4;
jumpSpeedY[1] = 4;

fallSpeedMax = 8;

counter[0] = 0;
jumpCounter = 0;
jumpCounterMax = 20;

gravDir = sign(image_yscale);
if(image_angle == 180)
{
	gravDir *= -1;
}
jumpXDir = 1;

function OnXCollision(fVX, isOOB = false)
{
	velX *= -1;
}

function CanMoveUpSlope_Top() { return true; }
function CanMoveDownSlope_Top() { return true; }

/*function OnSlopeXCollision_Bottom(fVX)
{
	if(gravDir == 1 && velY >= 0)
	{
		grounded = true;
	}
}
function OnSlopeXCollision_Top(fVX)
{
	if(gravDir == -1 && velY <= 0)
	{
		grounded = true;
	}
}*/
function OnYCollision(fVY, isOOB = false)
{
	if(gravDir == 1 && velY >= 0)
	{
		velX = 0;
		grounded = true;
	}
	if(gravDir == -1 && velY <= 0)
	{
		velX = 0;
		grounded = true;
	}
	velY = 0;
}