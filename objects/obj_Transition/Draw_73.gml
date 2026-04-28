if(surface_exists(transSurf))
{
	surface_resize(transSurf,ceil(global.zoomResWidth),ceil(global.zoomResHeight));
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    if(transSprtDraw)
    {
		var sx = scr_round(playerX),
			sy = scr_round(playerY);
		
        with(obj_Player)
        {
			var col = c_lime;
			gpu_set_fog(true,col,0,0);
			gpu_set_blendmode(bm_add);
			for(var i = 0; i < 360; i += 45)
			{
				for(var j = 1; j < 3; j++)
				{
					var gx = sx+scr_ceil(lengthdir_x(1,i)*j),
					gy = sy+scr_ceil(lengthdir_y(1,i)*j);
					DrawPlayer(gx,gy,rotation,0.5*(1/6));
				}
			}
			gpu_set_blendmode(bm_normal);
			gpu_set_fog(false,0,0,0);
			
			DrawPlayer(sx,sy,rotation,1);
			
			PostDrawPlayer(sx,sy,0,1);
        }
    }
	
	draw_surface_ext(application_surface,0,0,1,1,0,c_white,1-alpha);
    surface_reset_target();

	gpu_set_blendenable(false);
    draw_surface_ext(transSurf,global.cameraX,global.cameraY,1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
    transSurf = surface_create(ceil(global.zoomResWidth),ceil(global.zoomResHeight));
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    surface_reset_target();
}