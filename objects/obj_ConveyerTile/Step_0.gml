/// @description 

if(global.gamePaused)
{
	exit;
}

var player = instance_place(x,y-2,obj_Player);
if(!instance_exists(player))
{
	player = instance_place(x,y+2,obj_Player);
}
if(!instance_exists(player))
{
	player = instance_place(x+2,y,obj_Player);
}
if(!instance_exists(player))
{
	player = instance_place(x-2,y,obj_Player);
}

if(instance_exists(player))
{
	var _dir = image_angle + 180*(image_xscale < 0);
	
	player.shiftX += lengthdir_x(moveSpeed,_dir);
	player.shiftY += lengthdir_y(moveSpeed,_dir);
}