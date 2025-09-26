// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ElevatorTrans(goal,currentID,targetID,activeDir)
{
	global.pauseState = PauseState.RoomTrans;
	var fade = instance_create_depth(0,0,0,obj_ElevatorTrans);
	fade.goal = goal;
	fade.currentID = currentID;
	fade.targetID = targetID;
	fade.activeDir = activeDir;
}