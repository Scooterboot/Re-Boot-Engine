/// @description Unpause
event_inherited();
if(global.pauseState == PauseState.MessageBox)
{
	global.pauseState = PauseState.None;
}