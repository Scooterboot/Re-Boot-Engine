/// @description Re-Draw fade tile layers
if(!instance_exists(obj_TileFadeBlock))
{
	surface_free(fadeTileSurface);
	surface_free(fadeTileSurfaceTemp);
	surface_free(alphaMask);
}
else
{

	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]),
		appWidth = surface_get_width(application_surface),
		appHeight = surface_get_height(application_surface);

	if(!surface_exists(fadeTileSurface))
	{
		fadeTileSurface = surface_create(appWidth,appHeight);
		redraw_fade_layer();
	}
	else
	{
		redraw_fade_layer();
	}
	if !(surface_exists(fadeTileSurfaceTemp))
	{
	    fadeTileSurfaceTemp = surface_create(appWidth,appHeight);
	}
	if !(surface_exists(fadeTileSurfaceTemp2))
	{
	    fadeTileSurfaceTemp2 = surface_create(appWidth,appHeight);
	}

	if !(surface_exists(alphaMask))
	{
	    alphaMask = surface_create(appWidth,appHeight);
	    redraw_alpha();
	}
	else
	{
	    redraw_alpha();
	}


	surface_set_target(fadeTileSurfaceTemp);
	draw_clear_alpha(0,0);

	draw_surface(fadeTileSurface,0,0);

	gpu_set_blendmode_ext(bm_inv_src_alpha,bm_src_colour);
	gpu_set_colorwriteenable(0,0,0,1);
	draw_surface(alphaMask,0,0);
	gpu_set_colorwriteenable(1,1,1,1);
	gpu_set_blendmode(bm_normal);

	if(instance_exists(obj_XRay))
	{
		with(obj_XRay)
		{
			gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

			draw_primitive_begin(pr_trianglelist);
			draw_vertex_colour(visorX-camx,visorY-camy,0,0);
			draw_vertex_colour(visorX-camx+lengthdir_x(500,coneDir + coneSpread),visorY-camy+lengthdir_y(500,coneDir + coneSpread),0,0);
			draw_vertex_colour(visorX-camx+lengthdir_x(500,coneDir - coneSpread),visorY-camy+lengthdir_y(500,coneDir - coneSpread),0,0);
			draw_primitive_end();

			gpu_set_blendmode(bm_normal);
		}
	}

	surface_reset_target();
	
	surface_set_target(fadeTileSurfaceTemp2);
	draw_clear_alpha(c_black,0);
	
	gpu_set_blendmode(bm_add);
	draw_surface(fadeTileSurfaceTemp,0,0);
	gpu_set_blendmode(bm_normal);
	
	gpu_set_colorwriteenable(1,1,1,0);
	draw_surface(fadeTileSurfaceTemp,0,0);
	gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
	
	draw_surface(fadeTileSurfaceTemp2,camx,camy);
}

if(instance_exists(obj_XRay))
{
	with(obj_XRay)
	{
		draw_primitive_begin(pr_trianglestrip);
		for(var i = 0; i < 360-(coneSpread*2); i = min(i+45,360-(coneSpread*2)))
		{
		    var Dar = coneDir + coneSpread + i;
		    draw_vertex_colour(visorX,visorY,0,darkAlpha);
		    draw_vertex_colour(visorX+lengthdir_x(500,Dar),visorY+lengthdir_y(500,Dar),0,darkAlpha);
		}
		draw_vertex_colour(visorX,visorY,0,darkAlpha);
		draw_vertex_colour(visorX+lengthdir_x(500,coneDir - coneSpread),visorY+lengthdir_y(500,coneDir - coneSpread),0,darkAlpha);
		draw_primitive_end();
	}

	with(obj_Player)
	{
	    gpu_set_blendmode(bm_add);
		UpdatePlayerSurface(pal_XRay_Visor,1+xRayVisorFlash,0,0);
		DrawPlayer(x,y,rotation,obj_XRay.alpha);
	    gpu_set_blendmode(bm_normal);
	}
}