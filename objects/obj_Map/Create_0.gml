/// @description Initialize
mapSurf = surface_create(8,8);

playerMapX = 0;
playerMapY = 0;

global.rmMapSize = 256;

global.rmMapSprt = noone;
global.rmMapX = 0;
global.rmMapY = 0;

#region CreateMapRevealGrid()
function CreateMapRevealGrid(mapSprt)
{
	var grid = ds_grid_create(scr_floor(sprite_get_width(mapSprt)/8),scr_floor(sprite_get_height(mapSprt)/8));
	ds_grid_clear(grid,false);
	return grid;
}
#endregion

global.mapReveal_Debug = CreateMapRevealGrid(sprt_Map_DebugRooms);

#region GetMapGrid()
function GetMapGrid(mapSprt)
{
	var grid = -1;
	switch(mapSprt)
	{
		case sprt_Map_DebugRooms:
		{
			grid = global.mapReveal_Debug;
			break;
		}
	}
	return grid;
}
#endregion
prevGrid = GetMapGrid(noone);
#region DrawMap()
function DrawMap(mapSprt,posX,posY,mapX,mapY,mapWidth,mapHeight)
{
	var diffX = mapX,
		diffY = mapY;
	if(diffX < 0)
	{
		posX -= diffX;
		mapX -= diffX;
		mapWidth += diffX;
	}
	if(diffY < 0)
	{
		posY -= diffY;
		mapY -= diffY;
		mapHeight += diffY;
	}

	mapWidth = min(mapWidth,sprite_get_width(mapSprt)-mapX);
	mapHeight = min(mapHeight,sprite_get_height(mapSprt)-mapY);

	if(mapSprt != noone)
	{
		var reveal = GetMapGrid(mapSprt);
		var grey = true;

		if(surface_exists(mapSurf))
		{
			surface_resize(mapSurf,sprite_get_width(mapSprt),sprite_get_height(mapSprt));
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
		
			if(grey)
			{
				draw_sprite_part_ext(mapSprt,1,0,0,sprite_get_width(mapSprt),sprite_get_height(mapSprt),0,0,1,1,c_white,1);
			}
		
			if(ds_exists(reveal,ds_type_grid))
			{
				for(var i = 0; i < ds_grid_width(reveal); i++)
				{
					for(var j = 0; j < ds_grid_height(reveal); j++)
					{
						if(reveal[# i,j])
						{
							draw_sprite_part_ext(mapSprt,0,i*8,j*8,8,8,i*8,j*8,1,1,c_white,1);
						}
					}
				}
			}
		
			surface_reset_target();
		
			draw_surface_part_ext(mapSurf,mapX,mapY,mapWidth,mapHeight,posX,posY,1,1,c_white,1);
		}
		else
		{
			mapSurf = surface_create(sprite_get_width(mapSprt),sprite_get_height(mapSprt));
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
			surface_reset_target();
		}
	}
}
#endregion