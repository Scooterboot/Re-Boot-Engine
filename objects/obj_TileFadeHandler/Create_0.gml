/// @description Initialize

/*for(var i = 0; i < 4; i++)
{
	var lay = layer_get_id("Tiles_fade"+string(i));
	if(layer_exists(lay))
	{
		layer_set_visible(lay,false);
	}
}*/
tileLayers = scr_GetLayersFromString("Tiles_fade");
for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],false);
}

var appWidth = surface_get_width(application_surface),
	appHeight = surface_get_height(application_surface);
FadeTileSurface = surface_create(appWidth,appHeight);
FadeTileSurfaceTemp = surface_create(appWidth,appHeight);
FadeTileSurfaceTemp2 = surface_create(appWidth,appHeight);
AlphaMask = surface_create(appWidth,appHeight);


#region redraw_fade_layer()
function redraw_fade_layer()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(FadeTileSurface);
	draw_clear_alpha(0,0);
	
	/*for(var i = 3; i >= 0; i--)
	{
		var lay = layer_get_id("Tiles_fade"+string(i));
		if(layer_exists(lay))
		{
			var TilesFade = layer_tilemap_get_id(lay);
			draw_tilemap(TilesFade,-camx,-camy);
		}
	}*/
	for(var i = array_length(tileLayers)-1; i >= 0; i--)
	{
		var TilesFade = layer_tilemap_get_id(tileLayers[i]);
		if(layer_tilemap_exists(tileLayers[i],TilesFade))
		{
			draw_tilemap(TilesFade,-camx,-camy);
		}
	}

	surface_reset_target();
}
#endregion
#region redraw_alpha()
function redraw_alpha()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(AlphaMask);
	draw_clear_alpha(c_black,1);//0);

	with (obj_TileFadeBlock)
	{
		//gpu_set_blendmode_ext(bm_inv_src_alpha,bm_src_colour);
		gpu_set_blendenable(false);
		gpu_set_colorwriteenable(0,0,0,1);
		draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,image_alpha);
		gpu_set_colorwriteenable(1,1,1,1);
		gpu_set_blendenable(true);
		//gpu_set_blendmode(bm_normal);
	}

	surface_reset_target();
}
#endregion

redraw_fade_layer();
redraw_alpha();