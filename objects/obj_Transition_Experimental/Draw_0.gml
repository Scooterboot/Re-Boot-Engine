if(surface_exists(transSurf))
{
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    if(transSprtDraw)
    {
        with(obj_Player)
        {
			var tObj = obj_Transition_Experimental;
            PreDrawPlayer(tObj.samusX,tObj.samusY,0,1);
			
			var col = c_lime;
			gpu_set_fog(true,col,0,0);
			gpu_set_blendmode(bm_add);
			for(var i = 0; i < 360; i += 45)
			{
				for(var j = 1; j < 3; j++)
				{
					var gx = tObj.samusX+scr_ceil(lengthdir_x(1,i)*j),
					gy = tObj.samusY+scr_ceil(lengthdir_y(1,i)*j);
					DrawPlayer(gx,gy,rotation,1*(1/6));//,false);
				}
			}
			gpu_set_blendmode(bm_normal);
			gpu_set_fog(false,0,0,0);
			
            pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
            DrawPlayer(tObj.samusX,tObj.samusY,rotation,1);
            shader_reset();
            PostDrawPlayer(tObj.samusX,tObj.samusY,0,1);
            water_init(0);
        }
    }
    surface_reset_target();

    //draw_surface_ext(transSurf,camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]),1,1,0,c_white,alpha);
}
else
{
    transSurf = surface_create(global.resWidth,global.resHeight);
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    surface_reset_target();
}