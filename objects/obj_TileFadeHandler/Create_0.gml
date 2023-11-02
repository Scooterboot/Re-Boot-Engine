/// @description Initialize

tileLayers = scr_GetLayersFromString("Tiles_fade");
for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],false);
}

var appWidth = surface_get_width(application_surface),
	appHeight = surface_get_height(application_surface);
fadeTileSurface = surface_create(appWidth,appHeight);
fadeTileSurfaceTemp = surface_create(appWidth,appHeight);
alphaMask = surface_create(appWidth,appHeight);


#region redraw_fade_layer()
function redraw_fade_layer()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(fadeTileSurface);
	draw_clear_alpha(0,0);
	
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
	
	surface_set_target(alphaMask);
	draw_clear_alpha(c_black,0);

	with (obj_TileFadeBlock)
	{
		draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,image_alpha);
	}

	surface_reset_target();
}
#endregion

redraw_fade_layer();
redraw_alpha();