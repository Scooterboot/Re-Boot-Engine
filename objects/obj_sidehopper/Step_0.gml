/// @description Behavior & Animation
event_inherited();

if(grounded)
{
	image_index = 0;
	if(jumpCounter < 3 || jumpCounter > jumpCounterMax-3)
	{
		image_index = 1;
	}
}
else
{
	image_index = 2;
}