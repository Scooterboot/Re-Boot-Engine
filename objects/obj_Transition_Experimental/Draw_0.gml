/*if(surface_exists(transSurf))
{
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    if(transSprtDraw)
    {
        with(obj_Player)
        {
			var sx = scr_round(obj_Transition.samusX),
				sy = scr_round(obj_Transition.samusY);
			
            PreDrawPlayer(sx,sy,0,1);
			
			var col = c_lime;
			gpu_set_fog(true,col,0,0);
			gpu_set_blendmode(bm_add);
			for(var i = 0; i < 360; i += 45)
			{
				for(var j = 1; j < 3; j++)
				{
					var gx = sx+scr_ceil(lengthdir_x(1,i)*j),
					gy = sy+scr_ceil(lengthdir_y(1,i)*j);
					DrawPlayer(gx,gy,rotation,1*(1/6));//,false);
				}
			}
			gpu_set_blendmode(bm_normal);
			gpu_set_fog(false,0,0,0);
			
            pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
            DrawPlayer(sx,sy,rotation,1);
            shader_reset();
            PostDrawPlayer(sx,sy,0,1);
        }
    }
	var appSurfScale = 1;
	if(global.upscale == 7)
	{
		appSurfScale = 1/obj_Display.screenScale;
	}
	draw_surface_ext(application_surface,0,0,appSurfScale,appSurfScale,0,c_white,1-alpha);
    surface_reset_target();

	gpu_set_blendenable(false);
    draw_surface_ext(transSurf,camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]),1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
    transSurf = surface_create(global.resWidth,global.resHeight);
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    surface_reset_target();
}*/