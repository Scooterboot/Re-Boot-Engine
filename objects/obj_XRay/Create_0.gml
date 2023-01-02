/// @description Create and Alter Drawing

global.gamePaused = true;

var xbackdepth = layer_get_depth(layer_get_id("Tiles_bg0")) - 1;
BackDraw = instance_create_depth(x,y,xbackdepth,obj_XRayBack);
BackAlpha = 0.25;
BackAlphaNum = 1;

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
bgTileLayers = scr_GetLayersFromString("Tiles_bg");
for(var i = 0; i < array_length(bgTileLayers); i++)
{
	layer_set_visible(bgTileLayers[i],false);
}

xRaySound = noone;
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

OutlineSurf = surface_create(Width,Height);
OutlineSurf2 = surface_create(Width,Height);
OutlineSurfTemp = surface_create(Width,Height);
//oColorHue = 0;
outlineFlash = 0;

//FinalSurface = surface_create(Width,Height);

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
	for(var i = array_length(bgTileLayers)-1; i >= 0; i--)
	{
		var TilesBack = layer_tilemap_get_id(bgTileLayers[i]);
		if(layer_tilemap_exists(bgTileLayers[i],TilesBack))
		{
			draw_tilemap(TilesBack,-camera_get_view_x(view_camera[0]),-camera_get_view_y(view_camera[0]));
		}
	}

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
		if (!object_is_ancestor(object_index,obj_DoorHatch) && object_index != obj_DoorHatch && 
			!object_is_ancestor(object_index,obj_InteractStation) &&
			(!object_is_ancestor(object_index,obj_Breakable) || object_index == obj_NPCBlock || object_index == obj_Spikes))
		{
			draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,1);
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
#region xray_redraw_outline()
function xray_redraw_outline()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(OutlineSurf);
	draw_clear_alpha(c_black,0);

	with (obj_Tile)
	{
		if (!object_is_ancestor(object_index,obj_DoorHatch) && object_index != obj_DoorHatch && 
			!object_is_ancestor(object_index,obj_InteractStation) &&
			(!object_is_ancestor(object_index,obj_Breakable) || object_index == obj_NPCBlock) &&
			object_index != obj_Elevator)
		{
			draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
		}
	}
	with (obj_DoorHatch)
	{
		draw_sprite_ext(sprite_index,5,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
		
		var door = instance_place(x-lengthdir_x(image_xscale*2,image_angle),y-lengthdir_y(image_xscale*2,image_angle),obj_Door);
		if(instance_exists(door))
		{
			with(door)
			{
				draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
			}
		}
	}
	with(obj_Breakable)
	{
		draw_sprite_ext(sprt_Tile,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_outline2()
function xray_redraw_outline2()
{
	var camx = camera_get_view_x(view_camera[0]),
		camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(OutlineSurf2);
	draw_clear_alpha(c_black,0);
	
	/*var visorX = x - camx + lengthdir_x(1,ConeDir),
		visorY = y - camy + lengthdir_y(1,ConeDir);
	
	/*draw_primitive_begin(pr_linelist);
	draw_vertex_colour(visorX,visorY,c_white,1);
	draw_vertex_colour(visorX+lengthdir_x(500,ConeDir + ConeSpread),visorY+lengthdir_y(500,ConeDir + ConeSpread),c_white,0.5);
	draw_vertex_colour(visorX,visorY,c_white,1);
	draw_vertex_colour(visorX+lengthdir_x(500,ConeDir - ConeSpread),visorY+lengthdir_y(500,ConeDir - ConeSpread),c_white,0.5);
	draw_primitive_end();
	
	draw_primitive_begin(pr_trianglelist);
	draw_vertex_colour(visorX,visorY,c_white,0.5);
	draw_vertex_colour(visorX+lengthdir_x(500,ConeDir + ConeSpread),visorY+lengthdir_y(500,ConeDir + ConeSpread),c_white,0.5);
	draw_vertex_colour(visorX+lengthdir_x(500,ConeDir - ConeSpread),visorY+lengthdir_y(500,ConeDir - ConeSpread),c_white,0.5);
	draw_primitive_end();*/
	
	with(obj_Platform)
	{
		if(!XRayHide)
		{
			draw_set_color(c_white);
			draw_set_alpha(1);
			if(object_index == obj_PlatformSlope)
			{
				var psWidth = abs(bbox_right-bbox_left) + 1,
					psHeight = abs(bbox_bottom-bbox_top) + 1;
				var x1 = x-camx - 1,
					y1 = y-camy - 1,
					x2 = x1+psWidth*image_xscale,
					y2 = y1+psHeight*image_yscale;
				draw_line(x1,y1,x2,y2);
			}
			else
			{
				draw_line(bbox_left-camx-1,bbox_top-camy,bbox_right-camx,bbox_top-camy);
				for(var i = bbox_left-camx; i < bbox_right-camx-1; i+= 4)
				{
					draw_line(i,bbox_top-camy+1,i+2,bbox_top-camy+1);
				}
			}
		}
	}

	if(surface_exists(OutlineSurf))
	{
		shader_set(shd_Outline);

		var outlineColor = shader_get_uniform(shd_Outline,"outlineColor");
		shader_set_uniform_f(outlineColor, 1,1,1,1 );

		var outlineW = shader_get_uniform(shd_Outline,"outlineW");
		shader_set_uniform_f(outlineW, 1/Width);

		var outlineH = shader_get_uniform(shd_Outline,"outlineH")
		shader_set_uniform_f(outlineH, 1/Height)
	
		draw_surface_ext(OutlineSurf,0,0,1,1,0,c_white,1);
		shader_reset();
	}

	surface_reset_target();
}
#endregion

xray_redraw_front();
xray_redraw_back();
xray_redraw_alpha();
xray_redraw_break();
xray_redraw_outline();
xray_redraw_outline2();