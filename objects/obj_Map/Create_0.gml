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

// Map icons are arrays to make saving/loading super simple.
// I'll probably convert them into structs after some experimentation, but for now they work.
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
	
	var sprtW = sprite_get_width(sprt), sprtH = sprite_get_height(sprt);
	var gridWidth = floor(sprtW/global.mapSquareSizeW),
		gridHeight = floor(sprtH/global.mapSquareSizeH);
	grid = ds_grid_create(gridWidth,gridHeight);
	ds_grid_clear(grid,false);
	
	icons = ds_list_create();
	
	visited = false;
	stationUsed = false;
	
	surf = surface_create(sprtW, sprtH);
	updateSurf = true;
	
	function IconsConvertSpritesToStrings()
	{
		for(var k = 0, len = ds_list_size(icons); k < len; k++)
		{
			icons[| k][MapIconInd.SpriteIndex] = sprite_get_name(icons[| k][MapIconInd.SpriteIndex]);
		}
	}
	function IconsConvertStringsToSprites()
	{
		for(var k = 0, len = ds_list_size(icons); k < len; k++)
		{
			icons[| k][MapIconInd.SpriteIndex] = asset_get_index(icons[| k][MapIconInd.SpriteIndex]);
		}
	}
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
function DrawMapTile(mapSprt_Revealed,sprtInd_Revealed, mapSprt_Station,sprtInd_Station, mapGrid,gridX,gridY,gridW,gridH, stationUsed)
{
	var i = gridX, j = gridY;
	
	var msSizeW = global.mapSquareSizeW,
		msSizeH = global.mapSquareSizeH;
	
	var _x = i*msSizeW,
		_y = j*msSizeH;
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
		draw_sprite_part_ext(mapSprt_Station,sprtInd_Station, _l,_t,1,_h, _x,_y, 1,1,c_white,1);
	}
	
	// right square revealed
	var _maxX = gridW-1;
	if(i >= _maxX || (i < _maxX && mapGrid[# i+1,j]))
	{
		w2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt_Station,sprtInd_Station, _l+_w-1,_t,1,_h, _x+_w-1,_y, 1,1,c_white,1);
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
		draw_sprite_part_ext(mapSprt_Station,sprtInd_Station, _l,_t,_w,1, _x,_y, 1,1,c_white,1);
	}
	
	// bottom square revealed
	var _maxY = gridH-1;
	if(j >= _maxY || (j < _maxY && mapGrid[# i,j+1]))
	{
		h2 += 1;
	}
	else if(stationUsed)
	{
		draw_sprite_part_ext(mapSprt_Station,sprtInd_Station, _l,_t+_h-1,_w,1, _x,_y+_h-1, 1,1,c_white,1);
	}
	
	draw_sprite_part_ext(mapSprt_Revealed,sprtInd_Revealed, l2,t2,w2,h2, x2,y2, 1,1,c_white,1);
}
#endregion
#region DrawMap
function DrawMap(mapArea, drawX,drawY,drawWidth,drawHeight, mapX,mapY, isMinimap = false, baseAlpha = 0)
{
	if(mapArea != noone)
	{
		var _prevSci = gpu_get_scissor();
		gpu_set_scissor(drawX,drawY,drawWidth,drawHeight);
		
		if(baseAlpha > 0)
		{
			draw_sprite_stretched_ext(sprt_HUD_MapBase,0,drawX-mapX,drawY-mapY,sprite_get_width(mapArea.sprt),sprite_get_height(mapArea.sprt),c_white,baseAlpha);
		}
		
		if(surface_exists(mapArea.surf))
		{
			draw_surface_ext(mapArea.surf, drawX-mapX,drawY-mapY, 1,1,0,c_white,1);
		}
		
		var offX = drawX-mapX, offY = drawY-mapY;
		var mapGrid = mapArea.grid,
			mapIcons = mapArea.icons;
		var gridWidth = ds_grid_width(mapGrid),
			gridHeight = ds_grid_height(mapGrid);
		if(ds_exists(mapIcons,ds_type_list))
		{
			for(var i = 0, len = ds_list_size(mapIcons); i < len; i++)
			{
				var icon = mapIcons[| i];
				if(!is_array(icon)) continue;
				
				var iconLen = array_length(icon);
				if(iconLen < 9)
				{
					var _newIcon = self.CreateMapIcon(noone,0,0,0);
					array_copy(_newIcon,0, icon,0, iconLen);
					ds_list_set(mapIcons,i,_newIcon);
				}
				else if(sprite_exists(icon[MapIconInd.SpriteIndex]))
				{
					if(isMinimap && !icon[MapIconInd.ShowOnMini])
					{
						continue;
					}
					
					var _sprt = icon[MapIconInd.SpriteIndex],
						_x = icon[MapIconInd.XPos],
						_y = icon[MapIconInd.YPos];
						
					var _left = _x-sprite_get_xoffset(_sprt);
					if(_left+offX > drawX+drawWidth) { continue; }
					var _right = _left+sprite_get_width(_sprt);
					if(_right+offX < drawX) { continue; }
					
					var _top = _y-sprite_get_yoffset(_sprt);
					if(_top+offY > drawY+drawHeight) { continue; }
					var _bottom = _top+sprite_get_height(_sprt);
					if(_bottom+offY < drawY) { continue; }
					
					var iconMapX = clamp(floor(_x / global.mapSquareSizeW), 0, gridWidth),
						iconMapY = clamp(floor(_y / global.mapSquareSizeH), 0, gridHeight);
					if(!icon[MapIconInd.AlwaysShow] && !mapGrid[# iconMapX,iconMapY]) continue;
					
					var _subimg = icon[MapIconInd.ImageIndex],
						_xscale = icon[MapIconInd.XScale],
						_yscale = icon[MapIconInd.YScale],
						_rot = icon[MapIconInd.Rotation];
					
					draw_sprite_ext(_sprt, _subimg, _x+offX, _y+offY, _xscale, _yscale, _rot, c_white, 1);
				}
			}
		}
		
		gpu_set_scissor(_prevSci);
	}
}
#endregion
