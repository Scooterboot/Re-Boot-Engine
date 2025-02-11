/// @description 

if(is_struct(targetPoint))
{
	frameCounter++;
	if(frameCounter > 3)
	{
		frame = scr_wrap(frame+1, 0, array_length(frameSeq));
		frameCounter = 0;
	}
	
	draw_sprite_ext(sprite_index, frameSeq[frame], scr_round(targetPoint.x), scr_round(targetPoint.y), 1,1,0,c_white,1);
}
else
{
	frame = 0;
	frameCounter = 0;
}

//debug
if(obj_Display.debug > 0)
{
	var player = obj_Player;
	var pos = GetPlayerPos();
	var pX = pos.X, pY = pos.Y;
	
	draw_set_alpha(0.5);
	draw_set_color(c_gray);
	draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir),pY+lengthdir_y(player.grappleMaxDist,shootDir));
	draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir+assistRadius),pY+lengthdir_y(player.grappleMaxDist,shootDir+assistRadius));
	draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir-assistRadius),pY+lengthdir_y(player.grappleMaxDist,shootDir-assistRadius));
	
	if(is_struct(targetPoint))
	{
		draw_set_color(c_lime);
		draw_line(pX,pY, targetPoint.x,targetPoint.y);
	}
	
	if(obj_Display.debug == 1)
	{
		draw_set_color(c_orange);
		for(var i = 0; i < ds_list_size(grapPoint_list); i++)
		{
			var gp = grapPoint_list[| i];
			draw_circle(gp.x-1,gp.y-1,4,false);
		}
	}
	
	draw_set_alpha(1);
	draw_set_color(c_white);
}
//

ds_list_clear(grapPoint_list);
targetPoint = noone;