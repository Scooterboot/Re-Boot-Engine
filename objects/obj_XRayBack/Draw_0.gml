/// @description 
var camx = camera_get_view_x(view_camera[0]),
	camy = camera_get_view_y(view_camera[0]);

if !(instance_exists(obj_XRay))
{
	instance_destroy();
}
else
{
	with (obj_XRay)
	{
		if !(surface_exists(surfaceBack))
		{
			surfaceBack = surface_create(width,height);
			xray_redraw_back();
		}
		else if (refresh)
		{
		    xray_redraw_back();
		}
 
		if !(surface_exists(surfaceBackTemp))
		{
			surfaceBackTemp = surface_create(width,height);
		}
 
		visorX = x - camx;
		visorY = y - camy;
 
		surface_set_target(surfaceBackTemp);
		//draw_clear_alpha(0,0);
		if(surface_exists(application_surface))
		{
			draw_surface(application_surface,0,0);
		}
 
		draw_surface(surfaceBack,0,0);
		/*
		//gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);
		gpu_set_blendmode_ext(bm_inv_src_alpha, bm_src_colour);
		gpu_set_colorwriteenable(0,0,0,1);
 
		draw_primitive_begin(pr_trianglelist);
		draw_vertex_colour(visorX,visorY,0,0.375);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir + coneSpread),visorY+lengthdir_y(500,coneDir + coneSpread),0,0.5);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir - coneSpread),visorY+lengthdir_y(500,coneDir - coneSpread),0,0.5);
		draw_primitive_end();

		gpu_set_colorwriteenable(1,1,1,1);
		gpu_set_blendmode(bm_normal);
		*/
		surface_reset_target();

		draw_surface(surfaceBackTemp,camx,camy);
	
	
		visorX = x;
		visorY = y;
		
		draw_primitive_begin(pr_trianglelist);
		draw_vertex_colour(visorX,visorY,0,0.375);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir + coneSpread),visorY+lengthdir_y(500,coneDir + coneSpread),0,0.5);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir - coneSpread),visorY+lengthdir_y(500,coneDir - coneSpread),0,0.5);
		draw_primitive_end();
		
		if(backAlphaNum > 0)
		{
			if(backAlpha < 0.75)
			{
				backAlpha = min(backAlpha+0.0125,0.75);
			}
			else
			{
				backAlphaNum = -1;
			}
		}
		else if(backAlpha > 0.25)
		{
			backAlpha = max(backAlpha-0.0125,0.25);
		}
		else
		{
			backAlphaNum = 1;
		}
		
		gpu_set_blendmode(bm_add);
		draw_primitive_begin(pr_trianglelist);
		draw_vertex_colour(visorX,visorY,c_dkgray,backAlpha*0.5);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir + coneSpread),visorY+lengthdir_y(500,coneDir + coneSpread),c_dkgray,0);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir - coneSpread),visorY+lengthdir_y(500,coneDir - coneSpread),c_dkgray,0);
		draw_primitive_end();
		gpu_set_blendmode(bm_normal);
	}
}