surface_set_target(obj_Display.surfUI);
bm_set_one();

var vx = 0,//camera_get_view_x(view_camera[0]),
	vy = 0,//camera_get_view_y(view_camera[0]),
	vw = global.resWidth,
	vh = global.resHeight;

draw_set_alpha(min(screenFade[0],1));
draw_set_color(c_black);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

draw_set_alpha(min(screenFade[1],1));
draw_set_color(c_white);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

var sIndex = sprt_Player_DeathRight;
if(dir == -1)
{
    sIndex = sprt_Player_DeathLeft;
}
if(instance_exists(obj_Player))
{
	if(animSequence[frame] <= 0)
	{
		var palSprite = pal_Player_PowerSuit;
		if(obj_Player.item[Item.VariaSuit])
		{
			palSprite = pal_Player_VariaSuit;
		}
		if(obj_Player.item[Item.GravitySuit])
		{
			palSprite = pal_Player_GravitySuit;
		}
		chameleon_set(palSprite,0,0,0,1);
	}
	draw_sprite_ext(sIndex,animSequence[frame],vx+posX,vy+posY,dir,1,0,c_white,screenFade[0]);
	shader_reset();
}

draw_set_alpha(min(screenFade[2],1));
draw_set_color(c_black);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

draw_set_alpha(1);
draw_set_color(c_white);

gpu_set_blendmode(bm_normal);
surface_reset_target();