/// @description Initialize

global.mapSquareSize = 10;//8;
global.rmMapSize = 256;

global.rmMapIndex = -1;
global.rmMapArea = noone;
global.rmMapX = 0;
global.rmMapY = 0;

global.rmMapPixX = 0;
global.rmMapPixY = 0;

mapSurf = surface_create(global.mapSquareSize,global.mapSquareSize);

playerMapX = 0;
playerMapY = 0;
prevPlayerMapX = 0;
prevPlayerMapY = 0;

function GetMapPosX(_x)
{
	var roomSizeW = scr_floor(room_width / global.rmMapSize)-1
	return clamp(scr_floor((_x-global.rmMapPixX)/global.rmMapSize),0,roomSizeW) + global.rmMapX;
}
function GetMapPosY(_y)
{
	var roomSizeH = scr_floor(room_height / global.rmMapSize)-1;
	return clamp(scr_floor((_y-global.rmMapPixY)/global.rmMapSize),0,roomSizeH) + global.rmMapY;
}

#region AreaMap
function AreaMap(_mapSprite, _name) constructor
{
	sprt = _mapSprite;
	name = _name;
	
	var gridWidth = scr_floor(sprite_get_width(sprt)/global.mapSquareSize),
		gridHeight = scr_floor(sprite_get_height(sprt)/global.mapSquareSize);
	grid = ds_grid_create(gridWidth,gridHeight);
	ds_grid_clear(grid,false);
	
	icons = ds_list_create();
	
	/* map icons are arrays
	mapIcon[0] = sprite
	mapIcon[1] = image index
	mapIcon[2] = x pos in map pixels (not squares)
	mapIcon[3] = y pos in map pixels
	mapIcon[4] = xscale
	mapIcon[5] = yscale
	mapIcon[6] = rotation
	mapIcon[7] = whether to show on mini map (defaults to true)
	mapIcon[8] = whether to show independantly of discovered map tile (default false)
	*/
	
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
function DrawMap(mapArea,posX,posY,mapX,mapY,mapWidth,mapHeight,isMinimap = false,baseAlpha = 0)
{
	if(mapArea != noone)
	{
		var mapSprt = mapArea.sprt;
		var mapGrid = mapArea.grid;
		var mapIcons = mapArea.icons;
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
		
		var offX = -mapX, offY = -mapY;
		
		var msSize = global.mapSquareSize;

		if(surface_exists(mapSurf))
		{
			surface_resize(mapSurf,mapWidth,mapHeight);
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
			
			if(baseAlpha > 0)
			{
				draw_sprite_stretched_ext(sprt_UI_HMapBase,0,offX,offY,sprite_get_width(mapSprt),sprite_get_height(mapSprt),c_white,baseAlpha);
			}
		
			if(ds_exists(mapGrid,ds_type_grid))
			{
				var startX = max(floor(mapX/msSize),0), 
					endX = min(startX+ceil(mapWidth/msSize)+1,ds_grid_width(mapGrid)),
					startY = max(floor(mapY/msSize),0), 
					endY = min(startY+ceil(mapHeight/msSize)+1,ds_grid_height(mapGrid));
				for(var i = startX; i < endX; i++)
				{
					for(var j = startY; j < endY; j++)
					{
						if(mapGrid[# i,j])
						{
							draw_sprite_part_ext(mapSprt,0,i*msSize,j*msSize,msSize,msSize,offX+i*msSize,offY+j*msSize,1,1,c_white,1);
						}
						else if(grey)
						{
							draw_sprite_part_ext(mapSprt,1,i*msSize,j*msSize,msSize,msSize,offX+i*msSize,offY+j*msSize,1,1,c_white,1);
						}
					}
				}
			}
			
			if(ds_exists(mapIcons,ds_type_list))
			{
				for(var i = 0; i < ds_list_size(mapIcons); i++)
				{
					if(is_array(mapIcons[| i]) && array_length(mapIcons[| i]) > 6)
					{
						var icon = mapIcons[| i];
						var _sprt = asset_get_index(icon[0]);
						if(!sprite_exists(_sprt))
						{
							continue;
						}
						var _subimg = icon[1],
							_x = icon[2] + offX,
							_y = icon[3] + offY,
							_xscale = icon[4],
							_yscale = icon[5],
							_rot = icon[6],
							canShowOnMini = true,
							alwaysShow = false;
						
						if(array_length(icon) > 7)
						{
							canShowOnMini = icon[7];
						}
						if(array_length(icon) > 8)
						{
							alwaysShow = icon[8];
						}
						
						var iconMapX = clamp(scr_floor(icon[2] / msSize), 0, ds_grid_width(mapGrid)),
							iconMapY = clamp(scr_floor(icon[3] / msSize), 0, ds_grid_height(mapGrid));
						
						if((!isMinimap || canShowOnMini) && (mapGrid[# iconMapX,iconMapY] || alwaysShow))
						{
							draw_sprite_ext(_sprt,_subimg,_x,_y,_xscale,_yscale,_rot,c_white,1);
						}
					}
				}
			}
		
			surface_reset_target();
			
			draw_surface_ext(mapSurf,posX,posY,1,1,0,c_white,1);
		}
		else
		{
			mapSurf = surface_create(mapWidth,mapHeight);
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
			surface_reset_target();
		}
	}
}
#endregion