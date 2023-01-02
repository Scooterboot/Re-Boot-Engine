/// @description Draw obj_XRay's 100 depth tile surface
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
		if !(surface_exists(SurfaceBack))
		{
			SurfaceBack = surface_create(Width,Height);
			xray_redraw_back();
		}
 
		if !(surface_exists(SurfaceBackTemp))
		{
			SurfaceBackTemp = surface_create(Width,Height);
		}
 
		VisorX = x - camx;
		VisorY = y - camy; 
 
		// -- Get rid of the easy background surface shit whatever
 
		surface_set_target(SurfaceBackTemp);
		draw_clear_alpha(0,0);
 
		draw_surface(SurfaceBack,0,0);
 
		gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);
 
		//draw_set_alpha(0);
		//draw_triangle(VisorX,VisorY,VisorX+lengthdir_x(500,ConeDir+ConeSpread),VisorY+lengthdir_y(500,ConeDir+ConeSpread),VisorX+lengthdir_x(500,ConeDir-ConeSpread),VisorY+lengthdir_y(500,ConeDir-ConeSpread), 0);
		//draw_set_alpha(1);
		draw_primitive_begin(pr_trianglelist);
		draw_vertex_colour(VisorX,VisorY,0,0);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir + ConeSpread),VisorY+lengthdir_y(500,ConeDir + ConeSpread),0,0);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,0);
		draw_primitive_end();
 
		gpu_set_blendmode(bm_normal);
 
		surface_reset_target();

		draw_surface(SurfaceBackTemp,camx,camy);
	
	
		VisorX = x;
		VisorY = y;
		
		if(BackAlphaNum > 0)
		{
			if(BackAlpha < 0.75)
			{
				BackAlpha = min(BackAlpha+0.0125,0.75);
			}
			else
			{
				BackAlphaNum = -1;
			}
		}
		else if(BackAlpha > 0.25)
		{
			BackAlpha = max(BackAlpha-0.0125,0.25);
		}
		else
		{
			BackAlphaNum = 1;
		}
		
		gpu_set_blendmode(bm_add);
		draw_primitive_begin(pr_trianglelist);
		draw_vertex_colour(VisorX,VisorY,c_dkgray,BackAlpha);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir + ConeSpread),VisorY+lengthdir_y(500,ConeDir + ConeSpread),c_dkgray,0);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),c_dkgray,0);
		draw_primitive_end();
		
		gpu_set_blendmode(bm_normal);
	
		/*VisorX = x + lengthdir_x(1,ConeDir);
		VisorY = y + lengthdir_y(1,ConeDir);
	
		draw_primitive_begin(pr_linelist);
		draw_vertex_colour(VisorX,VisorY,c_ltgray,DarkAlpha);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir + ConeSpread),VisorY+lengthdir_y(500,ConeDir + ConeSpread),c_ltgray,DarkAlpha);
		draw_vertex_colour(VisorX,VisorY,c_ltgray,DarkAlpha);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),c_ltgray,DarkAlpha);
		draw_primitive_end();
		gpu_set_blendmode(bm_normal);*/
	}
}