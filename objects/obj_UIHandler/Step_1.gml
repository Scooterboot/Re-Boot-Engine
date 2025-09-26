/// @description Failsafes

if(global.pauseState != PauseState.None)
{
	if(room == rm_MainMenu || room == rm_GameOver || room == rm_Disclaimer)
	{
		global.pauseState = PauseState.None;
	}
	
	if ((global.pauseState == PauseState.MessageBox && !instance_exists(obj_MessageBox)) || 
		(global.pauseState == PauseState.RoomTrans && !instance_exists(obj_Transition)) || 
		(global.pauseState == PauseState.DeathAnim && !instance_exists(obj_DeathAnim)) || 
		(global.pauseState == PauseState.XRay && !instance_exists(obj_XRayVisor)))
	{
		global.pauseState = PauseState.None;
	}
}