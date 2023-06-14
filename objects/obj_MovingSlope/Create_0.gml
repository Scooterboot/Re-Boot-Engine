/// @description 
event_inherited();

function CheckPlayer_Top()
{
	var player = instance_place(x,y-1,obj_Player);
	if(instance_exists(player))
	{
		return player;
	}
	if(image_yscale > 0)
	{
		player = instance_place(x+sign(image_xscale),y-1,obj_Player);
	}
	return player;
}
function CheckPlayer_Bottom()
{
	var player = instance_place(x,y+1,obj_Player);
	if(instance_exists(player))
	{
		return player;
	}
	if(image_yscale < 0)
	{
		player = instance_place(x+sign(image_xscale),y+1,obj_Player);
	}
	return player;
}
function CheckPlayer_Left()
{
	var player = instance_place(x-1,y,obj_Player);
	if(instance_exists(player))
	{
		return player;
	}
	if(image_xscale < 0)
	{
		player = instance_place(x-1,y-sign(image_yscale),obj_Player);
	}
	return player;
}
function CheckPlayer_Right()
{
	var player = instance_place(x+1,y,obj_Player);
	if(instance_exists(player))
	{
		return player;
	}
	if(image_xscale > 0)
	{
		player = instance_place(x+1,y-sign(image_yscale),obj_Player);
	}
	return player;
}