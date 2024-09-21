/// @description Initialize

global.gamePaused = true;

var xbackdepth = layer_get_depth(layer_get_id("Tiles_bg0")) - 1;
backDraw = instance_create_depth(x,y,xbackdepth,obj_XRayBack);
backAlpha = 0.25;
backAlphaNum = 1;

coneDir = 0;
coneSpread = 0;
coneSpreadMax = 30;
coneLength = global.zoomResWidth*0.75;
visorX = x;
visorY = y;

kill = 0;

alpha = 0;
darkAlpha = 0;

refresh = 0;

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

width = surface_get_width(application_surface) + 64;
height = surface_get_height(application_surface) + 64;

surfaceFront = surface_create(width,height);
surfaceBack = surface_create(width,height);
surfaceFrontTemp = surface_create(width,height);
surfaceBackTemp = surface_create(width,height); 
alphaMask = surface_create(width,height);
alphaMaskTemp = surface_create(width,height);
breakMask = surface_create(width,height);
breakMaskTemp = surface_create(width,height);

outlineSurf = surface_create(width,height);
outlineSurf2 = surface_create(width,height);
outlineSurfTemp = surface_create(width,height);
outlineFlash = 0;

#region xray_refresh()
function xray_refresh()
{
	with (obj_XRay)
	{
		refresh = 1;
	}
}
#endregion
#region xray_redraw_front()
function xray_redraw_front()
{
	var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
		camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);
	
	surface_set_target(surfaceFront);
	draw_clear_alpha(0,0);

	for(var i = array_length(tileLayers)-1; i >= 0; i--)
	{
		var TilesFront = layer_tilemap_get_id(tileLayers[i]);
		if(layer_tilemap_exists(tileLayers[i],TilesFront))
		{
			draw_tilemap(TilesFront,layer_get_x(tileLayers[i])-camx,layer_get_y(tileLayers[i])-camy);
		}
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_back()
function xray_redraw_back()
{
	var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
		camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);
	
	surface_set_target(surfaceBack);
	draw_clear_alpha(0,0);

	for(var i = array_length(bgTileLayers)-1; i >= 0; i--)
	{
		var TilesBack = layer_tilemap_get_id(bgTileLayers[i]);
		if(layer_tilemap_exists(bgTileLayers[i],TilesBack))
		{
			draw_tilemap(TilesBack,layer_get_x(bgTileLayers[i])-camx,layer_get_y(bgTileLayers[i])-camy);
		}
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_alpha()
function xray_redraw_alpha()
{
	var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
		camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);
	
	surface_set_target(alphaMask);
	draw_clear_alpha(c_black,0);
	
	with (obj_Tile)
	{
		if (!object_is_ancestor(object_index,obj_DoorHatch) && object_index != obj_DoorHatch && 
			!object_is_ancestor(object_index,obj_InteractStation) &&
			(!object_is_ancestor(object_index,obj_Breakable) || object_index == obj_NPCBreakable || object_index == obj_Spikes))
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
	with(obj_InteractStation)
	{
		draw_sprite_ext(mask_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,1);
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_break()
function xray_redraw_break()
{
	var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
		camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);
	
	surface_set_target(breakMask);
	draw_clear_alpha(c_black,0);

	with (obj_Breakable)
	{
		if(object_index != obj_Spikes && object_index != obj_NPCBreakable)
		{
			DrawBreakable(x-camx,y-camy,image_index);
		}
	}
	with (obj_Item)
	{
		if(!visible)
		{
			draw_sprite_ext(sprite_index,image_index,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_white,1);
		}
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_outline()
function xray_redraw_outline()
{
	var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
		camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);
	
	surface_set_target(outlineSurf);
	draw_clear_alpha(c_black,0);

	with (obj_Tile)
	{
		if (!object_is_ancestor(object_index,obj_DoorHatch) && object_index != obj_DoorHatch && 
			!object_is_ancestor(object_index,obj_InteractStation) &&
			(!object_is_ancestor(object_index,obj_Breakable) || object_index == obj_NPCBreakable) &&
			object_index != obj_Elevator)
		{
			draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
		}
	}
	with(obj_Platform)
	{
		if(!xRayHide)
		{
			draw_set_color(c_black);
			draw_set_alpha(1);
			
			draw_line(bbox_left-camx-1,bbox_top-camy,bbox_right-camx-1,bbox_top-camy);
			for(var i = bbox_left-camx; i < bbox_right-camx-1; i+= 4)
			{
				draw_line(i,bbox_top-camy+1,i+2,bbox_top-camy+1);
			}
		}
	}
	with (obj_MovingTile)
	{
		draw_sprite_ext(sprite_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
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
		if(object_index != obj_Spikes)
		{
			draw_sprite_ext(sprt_Tile,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
		}
	}
	with(obj_InteractStation)
	{
		draw_sprite_ext(mask_index,1,x-camx,y-camy,image_xscale,image_yscale,image_angle,c_black,1);
	}

	surface_reset_target();
}
#endregion
#region xray_redraw_outline2()
function xray_redraw_outline2()
{
	//var camx = camera_get_view_x(view_camera[0]),
	//	camy = camera_get_view_y(view_camera[0]);
	
	surface_set_target(outlineSurf2);
	draw_clear_alpha(c_black,0);

	if(surface_exists(outlineSurf))
	{
		shader_set(shd_Outline);

		var outlineColor = shader_get_uniform(shd_Outline,"outlineColor");
		shader_set_uniform_f(outlineColor, 1,1,1,1 );

		var outlineW = shader_get_uniform(shd_Outline,"outlineW");
		shader_set_uniform_f(outlineW, 1/width);

		var outlineH = shader_get_uniform(shd_Outline,"outlineH")
		shader_set_uniform_f(outlineH, 1/height)
	
		draw_surface_ext(outlineSurf,0,0,1,1,0,c_white,1);
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