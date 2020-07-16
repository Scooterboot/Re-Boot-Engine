///scr_Transition(goal, currentID, targetID, difX, difY, spawnDist)
global.gamePaused = true;
var fade = instance_create_depth(0,0,0,obj_Transition);
fade.goal = argument0;
fade.currentID = argument1;
fade.targetID = argument2;
fade.difX = argument3;
fade.difY = argument4;
fade.spawnDist = argument5;