/// @description Unpause
event_inherited();
if(global.gamePaused && !obj_PauseMenu.pause)
{
	global.gamePaused = false;
}