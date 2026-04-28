/// @description Initialize

global.mapSquareSizeW = 10;//8;
global.mapSquareSizeH = 10;//8;
global.rmMapSizeW = 256;
global.rmMapSizeH = 256;

global.rmMapIndex = -1;
global.rmMapArea = noone;
global.rmMapX = 0;
global.rmMapY = 0;

global.rmMapPixX = 0;
global.rmMapPixY = 0;

mapSurf = surface_create(global.mapSquareSizeW,global.mapSquareSizeH);

playerMapX = 0;
playerMapY = 0;

function GetMapPosX(_x)
{
	var roomSizeW = floor(room_width / global.rmMapSizeW)-1;
	return clamp(floor((_x-global.rmMapPixX)/global.rmMapSizeW),0,roomSizeW) + global.rmMapX;
}
function GetMapPosY(_y)
{
	var roomSizeH = floor(room_height / global.rmMapSizeH)-1;
	return clamp(floor((_y-global.rmMapPixY)/global.rmMapSizeH),0,roomSizeH) + global.rmMapY;
}

#region Map Icon

// Map icons are arrays (and their sprite index is a string) to make saving/loading super simple
// I'll probably convert them into structs after some experimentation, but for now they work
enum MapIconInd
{
	SpriteIndex, //--0
	ImageIndex, //---1
	XPos, //---------2
	YPos, //---------3
	XScale, //-------4
	YScale, //-------5
	Rotation, //-----6
	ShowOnMini, //---7
	AlwaysShow //----8
}
function CreateMapIcon(_sprtInd, _imgInd, _x, _y, _xscale = 1, _yscale = 1, _rotation = 0, _showOnMini = true, _alwaysShow = false)
{
	return [_sprtInd, _imgInd, _x, _y, _xscale, _yscale, _rotation, _showOnMini, _alwaysShow];
}

/*function MapIcon(_sprtInd, _imgInd, _x, _y, _xscale = 1, _yscale = 1, _rotation = 0, _showOnMini = true, _alwaysRevealed = false) constructor
{
	spriteIndex = _sprtInd;
	imageIndex = _imgInd;
	x = _x;
	y = _y;
	xScale = _xscale;
	yScale = _yscale;
	rotation = _rotation;
	showOnMinimap = _showOnMini;
	alwaysRevealed = _alwaysRevealed;
}*/

#endregion

#region AreaMap
function AreaMap(_mapSprite, _name) constructor
{
	sprt = _mapSprite;
	name = _name;
	
	var gridWidth = floor(sprite_get_width(sprt)/global.mapSquareSizeW),
		gridHeight = floor(sprite_get_height(sprt)/global.mapSquareSizeH);
	grid = ds_grid_create(gridWidth,gridHeight);
	ds_grid_clear(grid,false);
	
	icons = ds_list_create();
	
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

#region DrawMapTile
function DrawMapTile(mapGrid, mapSprt, sprtInd, offX, offY, gridX, gridY, gridW, gridH, stationUsed)
{
	var i = gridX, j = gridY;
	
	var msSizeW = global.mapSquareSizeW,
		msSizeH = global.mapSquareSizeH;
	
	var _x = offX+i*msSizeW,
		_y = offY+j*msSizeH;
	var _l = i*msSizeW,
		_t = j*msSizeH,
		_w = msSizeW,
		_h = msSizeH;
	
	var x2 = _x + 1,
		y2 = _y + 1,
		l2 = _l + 1,
		t2 = _t + 1,
		w2 = _w - 2,
		h2 = _h - 2;
	
	// left map square revealed
	if(i <= 0 || (i > 0 && mapGrid[# i-1,j]))
	{
		x2 -= 1;
		l2 -= 1;
		w2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt,1, _l,_t,1,_h, _x,_y, 1,1,c_white,1);
	}
	
	// right square revealed
	var _maxX = gridW-1;
	if(i >= _maxX || (i < _maxX && mapGrid[# i+1,j]))
	{
		w2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt,1, _l+_w-1,_t,1,_h, _x+_w-1,_y, 1,1,c_white,1);
	}
	
	// top square revealed
	if(j <= 0 || (j > 0 && mapGrid[# i,j-1]))
	{
		y2 -= 1;
		t2 -= 1;
		h2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt,1, _l,_t,_w,1, _x,_y, 1,1,c_white,1);
	}
	
	// bottom square revealed
	var _maxY = gridH-1;
	if(j >= _maxY || (j < _maxY && mapGrid[# i,j+1]))
	{
		h2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt,1, _l,_t+_h-1,_w,1, _x,_y+_h-1, 1,1,c_white,1);
	}
	
	draw_sprite_part_ext(mapSprt,sprtInd, l2,t2,w2,h2, x2,y2, 1,1,c_white,1);
}
#endregion
#region DrawMap
function DrawMap(mapArea, posX,posY, mapX,mapY, mapWidth,mapHeight, isMinimap = false, baseAlpha = 0)
{
	if(mapArea != noone)
	{
		var mapSprt = mapArea.sprt;
		var mapGrid = mapArea.grid;
		var mapIcons = mapArea.icons;
		var stationUsed = mapArea.stationUsed;
		
		var gridWidth = floor(sprite_get_width(mapSprt)/global.mapSquareSizeW),
			gridHeight = floor(sprite_get_height(mapSprt)/global.mapSquareSizeH);
		
		if(mapX < 0)
		{
			posX -= mapX;
		}
		if(mapY < 0)
		{
			posY -= mapY;
		}
		
		var diffX = mapX,
			diffY = mapY;
		if(diffX < 0)
		{
			mapX -= diffX;
			mapWidth += diffX;
		}
		if(diffY < 0)
		{
			mapY -= diffY;
			mapHeight += diffY;
		}

		mapWidth = min(mapWidth,sprite_get_width(mapSprt)-mapX);
		mapHeight = min(mapHeight,sprite_get_height(mapSprt)-mapY);
		
		var offX = -mapX, offY = -mapY;
		
		var msSizeW = global.mapSquareSizeW,
			msSizeH = global.mapSquareSizeH;

		if(surface_exists(mapSurf))
		{
			surface_resize(mapSurf,mapWidth,mapHeight);
			surface_set_target(mapSurf);
			draw_clear_alpha(c_black,0);
			
			if(baseAlpha > 0)
			{
				draw_sprite_stretched_ext(sprt_HUD_MapBase,0,offX,offY,sprite_get_width(mapSprt),sprite_get_height(mapSprt),c_white,baseAlpha);
			}
		
			if(ds_exists(mapGrid,ds_type_grid))
			{
				var startX = max(floor(mapX/msSizeW),0), 
					endX = min(startX + ceil(mapWidth/msSizeW)+1, gridWidth),
					startY = max(floor(mapY/msSizeH),0), 
					endY = min(startY + ceil(mapHeight/msSizeH)+1, gridHeight);
				
				if(stationUsed)
				{
					for(var i = startX; i < endX; i++)
					{
						for(var j = startY; j < endY; j++)
						{
							if(!mapGrid[# i,j])
							{
								draw_sprite_part_ext(mapSprt,1, i*msSizeW,j*msSizeH,msSizeW,msSizeH, offX+i*msSizeW,offY+j*msSizeH, 1,1,c_white,1);
							}
						}
					}
				}
				for(var i = startX; i < endX; i++)
				{
					for(var j = startY; j < endY; j++)
					{
						if(mapGrid[# i,j])
						{
							DrawMapTile(mapGrid, mapSprt,0, offX,offY, i,j, gridWidth,gridHeight, stationUsed);
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
						//
						if(array_length(icon) <= 7) { icon[7] = true; }
						if(array_length(icon) <= 8) { icon[8] = false; }
						//
						var _sprt = asset_get_index(icon[MapIconInd.SpriteIndex]);
						if(!sprite_exists(_sprt))
						{
							continue;
						}
						var _subimg = icon[MapIconInd.ImageIndex],
							_x = icon[MapIconInd.XPos],
							_y = icon[MapIconInd.YPos],
							_xscale = icon[MapIconInd.XScale],
							_yscale = icon[MapIconInd.YScale],
							_rot = icon[MapIconInd.Rotation],
							_showOnMini = icon[MapIconInd.ShowOnMini],
							_alwaysShow = icon[MapIconInd.AlwaysShow];
						
						var iconMapX = clamp(floor(_x / msSizeW), 0, gridWidth),
							iconMapY = clamp(floor(_y / msSizeH), 0, gridHeight);
						
						if((!isMinimap || _showOnMini) && (mapGrid[# iconMapX,iconMapY] || _alwaysShow))
						{
							draw_sprite_ext(_sprt, _subimg, _x+offX, _y+offY, _xscale, _yscale, _rot, c_white, 1);
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
