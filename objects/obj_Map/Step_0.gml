/// @description Map Logic

if(room == rm_MainMenu)
{
	global.rmMapArea = noone;
	prevArea = noone;
	
	for(var i = 0; i < array_length(global.mapArea); i++)
	{
		ds_grid_clear(global.mapArea[i].grid,false);
		ds_list_clear(global.mapArea[i].icons);
			
		global.mapArea[i].visited = false;
		global.mapArea[i].stationUsed = false;
	}
}

if(instance_exists(obj_Player) && room != rm_MainMenu && global.rmMapArea != noone && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete || prevArea != global.rmMapArea))
{
	playerMapX = GetMapPosX(obj_Player.x);
	playerMapY = GetMapPosY(obj_Player.y);
	
	var grid = global.rmMapArea.grid;
	if(ds_exists(grid,ds_type_grid))
	{
		var mx = clamp(playerMapX,0,ds_grid_width(grid));
		var my = clamp(playerMapY,0,ds_grid_height(grid));
		if(playerMapX == mx && playerMapY == my)
		{
			grid[# playerMapX,playerMapY] = true;
		}
		global.rmMapArea.visited = true;
	}
}