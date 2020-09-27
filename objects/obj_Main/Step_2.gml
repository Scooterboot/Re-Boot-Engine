/// @description Map

if(instance_exists(obj_Player) && room != rm_MainMenu && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete))
{
	var playerMapX = scr_floor(obj_Player.x/global.rmMapSize) + global.rmMapX,
		playerMapY = scr_floor(obj_Player.y/global.rmMapSize) + global.rmMapY;

	if(global.rmMapSprt == sprt_Map_DebugRooms)
	{
		var mx = clamp(playerMapX,0,ds_grid_width(global.mapReveal_Debug));
		var my = clamp(playerMapY,0,ds_grid_height(global.mapReveal_Debug));
		global.mapReveal_Debug[# mx,my] = true;
	}
}