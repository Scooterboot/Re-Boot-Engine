/// @description 
event_perform_object(obj_Breakable,ev_step,0);

//var player = instance_place(x,y,obj_Player);
var player = noone;//collision_rectangle(bbox_left-1,bbox_top-1,bbox_right+1,bbox_bottom+1,obj_Player,false,true);
for(var i = 0; i < 360; i+= 90)
{
	if(place_meeting(x+lengthdir_x(1.5,i),y+lengthdir_y(1.5,i),obj_Player))
	{
		player = instance_place(x+lengthdir_x(1.5,i),y+lengthdir_y(1.5,i),obj_Player);
		break;
	}
}
if(instance_exists(player))
{
	var ang = 45;
	if(player.y > bbox_top+(bbox_bottom-bbox_top)/2)
	{
		ang = 315;
	}
	if(player.dir == 1)
	{
		ang = 135;
		if(player.y > bbox_top+(bbox_bottom-bbox_top)/2)
		{
			ang = 225;
		}
	}
	var knockX = lengthdir_x(knockBackSpeed,ang),
		knockY = lengthdir_y(knockBackSpeed,ang);
	player.StrikePlayer(damage,knockBack,knockX,knockY,damageInvFrames,true);
}

frameCounter++;
if(frameCounter > 8)
{
	frame = scr_wrap(frame+1,0,4);
	frameCounter = 0;
}
image_index = frameSeq[frame];