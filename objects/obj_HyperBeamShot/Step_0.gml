/// @description 

//particleType = scr_floor(obj_Display.hyperRainbowCycle/2);
particleType = 7+scr_floor(obj_Display.hyperRainbowCycle);

event_inherited();

/*
scr_OpenDoor(x,y,4);
scr_BreakBlock(x,y,7);
if(impact > 0)
{
	var xspeed = lengthdir_x(velocity,direction),
		yspeed = lengthdir_y(velocity,direction);
	xspeed += speed_x;
	yspeed += speed_y;
	
	scr_OpenDoor(x+sign(xspeed),y+sign(yspeed),4);
	scr_BreakBlock(x+sign(xspeed),y+sign(yspeed),7);
	scr_OpenDoor(x-xspeed,y-yspeed,4);
	scr_BreakBlock(x-xspeed,y-yspeed,7);
}
if(projLength > 0)
{
	var numw = max(projWidth,1),//sprite_xoffset*2,//abs(bbox_right - bbox_left),
        numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
	for(var j = -numw/2; j < numd; j += numw)
	{
		if(j > 0 || impact > 0)
		{
			var xw = x-lengthdir_x(j,direction),
				yw = y-lengthdir_y(j,direction);
			scr_OpenDoor(xw,yw,4);
			scr_BreakBlock(xw,yw,7);
		}
	}
}
*/