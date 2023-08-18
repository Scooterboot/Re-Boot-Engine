/// @description 
if(global.gamePaused)
{
	exit;
}

if(place_meeting(x,y,obj_Tile))
{
	instance_destroy();
}

if(velX > 0)
{
	velX = max(velX-frict,0);
}
if(velX < 0)
{
	velX = min(velX+frict,0);
}
velY += grav;

x += velX;
y += velY;