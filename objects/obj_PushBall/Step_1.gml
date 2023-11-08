/// @description 

if(global.gamePaused)
{
	exit;
}

event_inherited();

if(fVelX != 0)
{
	rotation += point_direction(x,y,xprevious,bbox_bottom)+90;
}