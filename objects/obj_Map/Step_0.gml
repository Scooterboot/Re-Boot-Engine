/// @description Map Logic

var grid = GetMapGrid(global.rmMapSprt);

if(instance_exists(obj_Player) && room != rm_MainMenu && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete || prevGrid != grid))
{
	var roomSizeW = scr_floor(room_width / global.rmMapSize)-1,
		roomSizeH = scr_floor(room_height / global.rmMapSize)-1;
	
	playerMapX = clamp(scr_floor(obj_Player.x/global.rmMapSize),0,roomSizeW) + global.rmMapX;
	playerMapY = clamp(scr_floor(obj_Player.y/global.rmMapSize),0,roomSizeH) + global.rmMapY;

	if(ds_exists(grid,ds_type_grid))
	{
		var mx = clamp(playerMapX,0,ds_grid_width(grid));
		var my = clamp(playerMapY,0,ds_grid_height(grid));
		if(playerMapX == mx && playerMapY == my)
		{
			grid[# playerMapX,playerMapY] = true;
		}
	}
}

prevGrid = grid;