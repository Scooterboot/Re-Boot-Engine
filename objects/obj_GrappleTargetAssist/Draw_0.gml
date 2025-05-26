/// @description 

if(!instance_exists(obj_Player))
{
	instance_destroy();
	exit;
}
var player = obj_Player;
var pos = GetPlayerPos();
var pX = pos.X, pY = pos.Y;

if(is_struct(targetPoint))
{
	frame += 0.0625 * frameNum;
	if(frame >= 1)
	{
		frameNum = -1;
		frame = 1;
	}
	if(frame <= 0)
	{
		frameNum = 1;
		frame = 0;
	}
	
	var alpha = min(0.375 + 0.375*frame, 1);
	var frameFinal = scr_round((image_number-1)*frame);
	var lineCol = [make_color_rgb(72,168,56), make_color_rgb(100,196,37), make_color_rgb(136,232,16), make_color_rgb(221,255,97)];
	var lineCol2 = make_color_rgb(46,107,0);
	
	var targetDir = point_direction(targetPoint.x,targetPoint.y, pX,pY);
	var targetDist = point_distance(targetPoint.x,targetPoint.y, player.x,player.y);
	var _dist = 64 * (targetDist / player.grappleMaxDist);
	
	for(var i = 0; i < _dist; i++)
	{
		var dif = 1 - (i / _dist);
		if(i < 3)
		{
			dif *= (i+1)/3;
		}
		var col = merge_color(lineCol2, lineCol[frameFinal], dif);
		
		for(var k = 0; k < 2; k++)
		{
			var px = targetPoint.x + lengthdir_x(8,targetDir+90),
				py = targetPoint.y + lengthdir_y(8,targetDir+90);
			if(k > 0)
			{
				px = targetPoint.x + lengthdir_x(8,targetDir-90);
				py = targetPoint.y + lengthdir_y(8,targetDir-90);
			}
			var pdir = point_direction(px,py, pX,pY);
			draw_sprite_ext(sprt_ParticlePixel2,0, px+lengthdir_x(i,pdir)+0.5,py+lengthdir_y(i,pdir)+0.5, 1,1,0, col, dif*alpha);
		}
	}
	
	draw_sprite_ext(sprite_index, scr_round((image_number-1)*frame), scr_round(targetPoint.x), scr_round(targetPoint.y), 1,1,0,c_white,alpha);
}
else
{
	frame = 0;
	frameNum = 1;
}

//debug
if(obj_Display.debug > 0)
{
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