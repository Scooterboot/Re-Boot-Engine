/// @description Create and Alter Drawing

global.gamePaused = true;

//BackDraw = instance_create(x,y,obj_XRayBack);

ConeDir = 0;
ConeSpread = 0;
VisorX = x;
VisorY = y;

Die = 0;

Alpha = 0;
DarkAlpha = 0;

RefreshThisFrame = 0;

//for(var i = 0; i < 4; i++)
//{
//	var lay = layer_get_id("Tiles_fg"+string(i));
//	if(layer_exists(lay))
//	{
//		layer_set_visible(lay,false);
//	}
//	/*lay = layer_get_id("Tiles_bg"+string(i));
//	if(layer_exists(lay))
//	{
//		layer_set_visible(lay,false);
//	}*/
//}
tileLayers = scr_GetLayersFromString("Tiles_fg");
for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],false);
}

xRaySoundPlayed = false;

Width = surface_get_width(application_surface);
Height = surface_get_height(application_surface);

SurfaceFront = surface_create(Width,Height);
SurfaceBack = surface_create(Width,Height);
SurfaceFrontTemp = surface_create(Width,Height);
SurfaceBackTemp = surface_create(Width,Height); 
AlphaMask = surface_create(Width,Height);
AlphaMaskTemp = surface_create(Width,Height);
BreakMask = surface_create(Width,Height);
BreakMaskTemp = surface_create(Width,Height);

FinalSurface = surface_create(Width,Height);

#region xray_refresh()
function xray_refresh()
{
	// Use rarely. Slow.
	with (obj_XRay)
	{
		RefreshThisFrame = 1;
	}
}
#endregion
#region xray_redraw_front()
function xray_redraw_front()
{
	surface_set_target(SurfaceFront);
	draw_clear_alpha(0,0);

	/*for(var i = 3; i >= 0; i--)
	{
		var lay = layer_get_id("Tiles_fg"+string(i));
		if(layer_exists(lay))
		{
			var TilesFront = layer_tilemap_get_id(lay);
			if(layer_tilemap_exists(lay,TilesFront))
			{
				draw_tilemap(TilesFront,-camera_get_view_x(view_camera[0]),-camera_get_view_y(view_camera[0]));
			}
		}
	}*/
	for(var i = array_length(tileLayers)-1; i >= 0; i--)
	{
		var TilesFront = layer_tilemap_get_id(tileLayers[i]);
		if(layer_tilemap_exists(tileLayers[i],TilesFront))
		{
			draw_tilemap(TilesFront,-camera_get_view_x(view_camera[0]),-camera_get_view_y(view_camera[0]));
		}
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_back()
function xray_redraw_back()
{
	surface_set_target(SurfaceBack);
	draw_clear_alpha(0,0);

	/*for(var i = 3; i >= 0; i--)
	{
		var lay = layer_get_id("Tiles_bg"+string(i));
		if(layer_exists(lay))
		{
			var TilesFront = layer_tilemap_get_id(lay);
			draw_tilemap(TilesFront,-camera_get_view_x(view_camera[0]),-camera_get_view_y(view_camera[0]));
		}
	}*/

	surface_reset_target();
}
#endregion
#region xray_redraw_alpha()
function xray_redraw_alpha()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(AlphaMask);
	draw_clear_alpha(c_black,0);

	//gpu_set_blendenable(false);
	//gpu_set_colorwriteenable(0,0,0,1);
	
	with (obj_Tile)
	{
		if((!object_is_ancestor(object_index,obj_Breakable) && !object_is_ancestor(object_index,obj_DoorHatch)) ||
			object_index == obj_NPCBlock || object_index == obj_Spikes)
		{
			var alpha = 1;
			/*if(object_index == obj_Spikes)
			{
				alpha = 0.5;
			}*/
			draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,alpha);
		}
	}
	with (obj_DoorHatch)
	{
		draw_sprite_ext(sprite_index,5,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,1);
	}
	with (obj_Door)
	{
	    draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,1);
	}
	
	//gpu_set_colorwriteenable(1,1,1,1);
	//gpu_set_blendenable(true);

	surface_reset_target();
}
#endregion
#region xray_redraw_break()
function xray_redraw_break()
{
	surface_set_target(BreakMask);
	draw_clear_alpha(c_black,0);

	with (obj_Breakable)
	{
		if(object_index != obj_Spikes && object_index != obj_NPCBlock)
		{
			//draw_sprite_ext(sprite_index,1,x-camera_get_view_x(view_camera[0]),y-camera_get_view_y(view_camera[0]),1,1,0,c_white,1);
			DrawBreakable(x-camera_get_view_x(view_camera[0]),y-camera_get_view_y(view_camera[0]),image_index);
		}
	}
	with (obj_Pickup)
	{
		draw_sprite_ext(sprite_index,image_index,x-camera_get_view_x(view_camera[0]),y-camera_get_view_y(view_camera[0]),image_xscale,image_yscale,image_angle,c_white,1);
	}

	surface_reset_target();
}
#endregion

xray_redraw_front();
xray_redraw_back();
xray_redraw_alpha();
xray_redraw_break();