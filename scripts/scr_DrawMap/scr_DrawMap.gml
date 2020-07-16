/// @description scr_DrawMap
/// @param mapSprt
/// @param posX
/// @param posY
/// @param mapX
/// @param mapY
/// @param mapWidth
/// @param mapHeight
/// @param drawMap=true

var mapSprt = argument[0],
posX = scr_round(argument[1]),
posY = scr_round(argument[2]),
mapX = scr_round(argument[3]),
mapY = scr_round(argument[4]),
mapWidth = argument[5],
mapHeight = argument[6],
drawMap = true;

var diffX = mapX,//posX - mapX,
	diffY = mapY;//posY - mapY;
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

if(argument_count > 7)
{
	drawMap = argument[7];
}

if(mapSprt != noone)
{
	var reveal = noone;
	var grey = true;
	
	if(mapSprt == sprt_Map_DebugRooms)
	{
		reveal = global.mapReveal_Debug;
	}

	if(surface_exists(mapSurf))
	{
		surface_resize(mapSurf,sprite_get_width(mapSprt),sprite_get_height(mapSprt));
		surface_set_target(mapSurf);
		draw_clear_alpha(c_black,0);
		
		if(grey)
		{
			draw_sprite_part_ext(mapSprt,1,0,0,sprite_get_width(mapSprt),sprite_get_height(mapSprt),0,0,1,1,c_white,1);
		}
		
		if(reveal != noone)
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
		
		if(drawMap)
		{
			draw_surface_part_ext(mapSurf,mapX,mapY,mapWidth,mapHeight,posX,posY,1,1,c_white,1);
		}
	}
	else
	{
		mapSurf = surface_create(sprite_get_width(mapSprt),sprite_get_height(mapSprt));
		surface_set_target(mapSurf);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}