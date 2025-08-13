/// @description Re-Draw fade tile layers
if(!instance_exists(obj_TileFadeBlock))
{
	surface_free(fadeTileSurface);
	surface_free(fadeTileSurfaceTemp);
	surface_free(alphaMask);
}
else
{

	var camX = camera_get_view_x(view_camera[0]),
		camY = camera_get_view_y(view_camera[0]),
		camW = camera_get_view_width(view_camera[0]),
		camH = camera_get_view_height(view_camera[0]);

	if(!surface_exists(fadeTileSurface))
	{
		fadeTileSurface = surface_create(camW,camH);
		redraw_fade_layer();
	}
	else
	{
		redraw_fade_layer();
	}
	if !(surface_exists(fadeTileSurfaceTemp))
	{
	    fadeTileSurfaceTemp = surface_create(camW,camH);
	}

	if !(surface_exists(alphaMask))
	{
	    alphaMask = surface_create(camW,camH);
	    redraw_alpha();
	}
	else
	{
	    redraw_alpha();
	}
	
	surface_resize(fadeTileSurfaceTemp,camW,camH);
	
	surface_set_target(fadeTileSurfaceTemp);
	//draw_clear_alpha(0,0);
	if(surface_exists(application_surface))
	{
		draw_surface(application_surface,0,0);
	}

	draw_surface(fadeTileSurface,0,0);

	gpu_set_blendmode_ext(bm_inv_src_alpha, bm_src_colour);
	gpu_set_colorwriteenable(0,0,0,1);
	draw_surface(alphaMask,0,0);
	gpu_set_colorwriteenable(1,1,1,1);
	gpu_set_blendmode(bm_normal);

	if(instance_exists(obj_XRayVisor))
	{
		with(obj_XRayVisor)
		{
			gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

			draw_primitive_begin(pr_trianglelist);
			draw_vertex_colour(visorX-camX,visorY-camY,0,0);
			draw_vertex_colour(visorX-camX+lengthdir_x(coneLength,coneDir + coneSpread),visorY-camY+lengthdir_y(coneLength,coneDir + coneSpread),0,0);
			draw_vertex_colour(visorX-camX+lengthdir_x(coneLength,coneDir - coneSpread),visorY-camY+lengthdir_y(coneLength,coneDir - coneSpread),0,0);
			draw_primitive_end();

			gpu_set_blendmode(bm_normal);
		}
	}

	surface_reset_target();
	
	draw_surface(fadeTileSurfaceTemp,camX,camY);
}

if(instance_exists(obj_XRayVisor))
{
	with(obj_XRayVisor)
	{
		draw_primitive_begin(pr_trianglestrip);
		for(var i = 0; i < 360-(coneSpread*2); i = min(i+45,360-(coneSpread*2)))
		{
		    var Dar = coneDir + coneSpread + i;
		    draw_vertex_colour(visorX,visorY,0,darkAlpha);
		    draw_vertex_colour(visorX+lengthdir_x(coneLength,Dar),visorY+lengthdir_y(coneLength,Dar),0,darkAlpha);
		}
		draw_vertex_colour(visorX,visorY,0,darkAlpha);
		draw_vertex_colour(visorX+lengthdir_x(coneLength,coneDir - coneSpread),visorY+lengthdir_y(coneLength,coneDir - coneSpread),0,darkAlpha);
		draw_primitive_end();
	}

	/*with(obj_Player)
	{
	    gpu_set_blendmode(bm_add);
		//UpdatePlayerSurface(pal_XRay_Visor,1+xRayVisorFlash,0,0);
		UpdatePlayerSurface(pal_XRay_Visor,0,1,0,xRayVisorFlash,0,2);
		DrawPlayer(x,y,rotation,obj_XRay.alpha);
	    gpu_set_blendmode(bm_normal);
	}*/
}