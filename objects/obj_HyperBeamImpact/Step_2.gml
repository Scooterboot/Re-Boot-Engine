/// @description 
event_inherited();
if(global.GamePaused())
{
	exit;
}

frameCounter++;
if(frameCounter > 1)
{
	frame++;
	frameCounter = 0;
}
if(frame >= image_number)
{
	instance_destroy();
}