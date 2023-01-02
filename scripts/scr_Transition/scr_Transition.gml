///scr_Transition(goal, currentID, targetID, difX, difY, spawnDist)
function scr_Transition(argument0, argument1, argument2, argument3, argument4, argument5)
{
	global.gamePaused = true;
	var fade = instance_create_depth(0,0,0,obj_Transition);
	//var fade = instance_create_depth(0,0,0,obj_Transition_Experimental);
	fade.goal = argument0;
	fade.currentID = argument1;
	fade.targetID = argument2;
	fade.difX = argument3;
	fade.difY = argument4;
	fade.spawnDist = argument5;
}
