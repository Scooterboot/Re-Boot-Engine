///scr_Transition(goal, currentID, targetID, difX, difY, spawnDist)
function scr_Transition(goal, currentID, targetID, difX, difY, spawnDist)
{
	global.gamePaused = true;
	var fade = instance_create_depth(0,0,0,obj_Transition);
	//var fade = instance_create_depth(0,0,0,obj_Transition_Experimental);
	fade.goal = goal;
	fade.currentID = currentID;
	fade.targetID = targetID;
	fade.difX = difX;
	fade.difY = difY;
	fade.spawnDist = spawnDist;
}
