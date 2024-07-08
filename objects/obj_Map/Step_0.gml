/// @description Map Logic

if(instance_exists(obj_Player) && room != rm_MainMenu && global.rmMapArea != noone && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete /*|| prevGrid != grid*/))
{
	var roomSizeW = scr_floor(room_width / global.rmMapSize)-1,
		roomSizeH = scr_floor(room_height / global.rmMapSize)-1;
	
	playerMapX = clamp(scr_floor((obj_Player.x-global.rmMapPixX)/global.rmMapSize),0,roomSizeW) + global.rmMapX;
	playerMapY = clamp(scr_floor((obj_Player.y-global.rmMapPixY)/global.rmMapSize),0,roomSizeH) + global.rmMapY;

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

prevArea = global.rmMapArea;