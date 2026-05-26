/// @description Unpause

if(global.pauseState == PauseState.MessageBox)
{
	global.pauseState = PauseState.None;
}
