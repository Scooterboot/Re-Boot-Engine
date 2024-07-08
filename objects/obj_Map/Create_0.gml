/// @description Initialize
mapSurf = surface_create(8,8);

playerMapX = 0;
playerMapY = 0;

global.rmMapSize = 256;

global.rmMapIndex = -1;
global.rmMapArea = noone;
global.rmMapX = 0;
global.rmMapY = 0;

global.rmMapPixX = 0;
global.rmMapPixY = 0;

#region AreaMap
function AreaMap(_mapSprite, _name) constructor
{
	sprt = _mapSprite;
	name = _name;
	
	grid = ds_grid_create(scr_floor(sprite_get_width(sprt)/8),scr_floor(sprite_get_height(sprt)/8));
	ds_grid_clear(grid,false);
	
	visited = false;
	stationUsed = false;
}
#endregion

enum MapArea
{
	Crateria = 0,
	WreckedShip = 1,
	Brinstar = 2,
	Maridia = 3,
	Norfair = 4,
	Tourian = 5
}
global.mapArea[MapArea.Crateria] = new AreaMap(sprt_Map_DebugCrateria, "Crateria");
global.mapArea[MapArea.WreckedShip] = new AreaMap(sprt_Map_DebugWreckedShip, "WreckedShip");
global.mapArea[MapArea.Brinstar] = new AreaMap(sprt_Map_DebugBrinstar, "Brinstar");
global.mapArea[MapArea.Norfair] = new AreaMap(sprt_Map_DebugNorfair, "Norfair");
global.mapArea[MapArea.Maridia] = new AreaMap(sprt_Map_DebugMaridia, "Maridia");
global.mapArea[MapArea.Tourian] = new AreaMap(sprt_Map_DebugTourian, "Tourian");

prevArea = noone;

#region DrawMap()
function DrawMap(mapArea,posX,posY,mapX,mapY,mapWidth,mapHeight)
{
	if(mapArea != noone)
	{
		var mapSprt = mapArea.sprt;
		var mapGrid = mapArea.grid;
		var grey = mapArea.stationUsed;
		
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

		if(surface_exists(mapSurf))
		{
			surface_resize(mapSurf,sprite_get_width(mapSprt),sprite_get_height(mapSprt));
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
		
			if(ds_exists(mapGrid,ds_type_grid))
			{
				for(var i = 0; i < ds_grid_width(mapGrid); i++)
				{
					for(var j = 0; j < ds_grid_height(mapGrid); j++)
					{
						if(mapGrid[# i,j])
						{
							draw_sprite_part_ext(mapSprt,0,i*8,j*8,8,8,i*8,j*8,1,1,c_white,1);
						}
						else if(grey)
						{
							draw_sprite_part_ext(mapSprt,1,i*8,j*8,8,8,i*8,j*8,1,1,c_white,1);
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