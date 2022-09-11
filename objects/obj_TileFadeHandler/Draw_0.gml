/// @description Re-Draw fade tile layers
if(!instance_exists(obj_TileFadeBlock))
{
	surface_free(FadeTileSurface);
	surface_free(FadeTileSurfaceTemp);
	surface_free(AlphaMask);
}
else
{

	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]),
		appWidth = surface_get_width(application_surface),
		appHeight = surface_get_height(application_surface);

	if(!surface_exists(FadeTileSurface))
	{
		FadeTileSurface = surface_create(appWidth,appHeight);
		redraw_fade_layer();
	}
	else
	{
		redraw_fade_layer();
	}
	if !(surface_exists(FadeTileSurfaceTemp))
	{
	    FadeTileSurfaceTemp = surface_create(appWidth,appHeight);
	}
	if !(surface_exists(FadeTileSurfaceTemp2))
	{
	    FadeTileSurfaceTemp2 = surface_create(appWidth,appHeight);
	}

	if !(surface_exists(AlphaMask))
	{
	    AlphaMask = surface_create(appWidth,appHeight);
	    redraw_alpha();
	}
	else
	{
	    redraw_alpha();
	}


	surface_set_target(FadeTileSurfaceTemp);
	draw_clear_alpha(0,0);

	draw_surface(FadeTileSurface,0,0);

	gpu_set_blendmode_ext(bm_inv_src_alpha,bm_src_colour);
	gpu_set_colorwriteenable(0,0,0,1);
	draw_surface(AlphaMask,0,0);
	gpu_set_colorwriteenable(1,1,1,1);
	gpu_set_blendmode(bm_normal);

	if(instance_exists(obj_XRay))
	{
		with(obj_XRay)
		{
			gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

			draw_primitive_begin(pr_trianglelist);
			draw_vertex_colour(VisorX-camx,VisorY-camy,0,0);
			draw_vertex_colour(VisorX-camx+lengthdir_x(500,ConeDir + ConeSpread),VisorY-camy+lengthdir_y(500,ConeDir + ConeSpread),0,0);
			draw_vertex_colour(VisorX-camx+lengthdir_x(500,ConeDir - ConeSpread),VisorY-camy+lengthdir_y(500,ConeDir - ConeSpread),0,0);
			draw_primitive_end();

			gpu_set_blendmode(bm_normal);
		}
	}

	surface_reset_target();

	//draw_surface(FadeTileSurfaceTemp,camx,camy);
	
	surface_set_target(FadeTileSurfaceTemp2);
	draw_clear_alpha(c_black,0);
	
	gpu_set_blendmode(bm_add);
	draw_surface(FadeTileSurfaceTemp,0,0);
	gpu_set_blendmode(bm_normal);
	
	gpu_set_colorwriteenable(1,1,1,0);
	draw_surface(FadeTileSurfaceTemp,0,0);
	gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
	
	draw_surface(FadeTileSurfaceTemp2,camx,camy);
}

if(instance_exists(obj_XRay))
{
	with(obj_XRay)
	{
		draw_primitive_begin(pr_trianglestrip);
		for(var i = 0; i < 360-(ConeSpread*2); i = min(i+45,360-(ConeSpread*2)))
		{
		    var Dar = ConeDir + ConeSpread + i;
		    draw_vertex_colour(VisorX,VisorY,0,DarkAlpha);
		    draw_vertex_colour(VisorX+lengthdir_x(500,Dar),VisorY+lengthdir_y(500,Dar),0,DarkAlpha);
		}
		draw_vertex_colour(VisorX,VisorY,0,DarkAlpha);
		draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,DarkAlpha);
		draw_primitive_end();
	}

	with(obj_Player)
	{
	    gpu_set_blendmode(bm_add);
	    pal_swap_set(pal_XRay_Visor,1+xRayVisorFlash,0,0,false);
		DrawPlayer(x,y,rotation,obj_XRay.Alpha);
	    shader_reset();
	    gpu_set_blendmode(bm_normal);
	}
}