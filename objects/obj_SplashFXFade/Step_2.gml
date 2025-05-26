/// @description 

if(global.gamePaused)
{
	exit;
}

x += velX;
y += velY;

image_alpha -= animSpeed;
if(image_alpha <= 0)
{
	instance_destroy();
}

if(place_meeting(x,y,solids))
{
	instance_destroy();
}