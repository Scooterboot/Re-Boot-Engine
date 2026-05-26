
__InputCollect();

for(var i = 0; i < INPUT_VERB._Length; i++)
{
	global.control[i] = global.controlInput[i].GetInput();
}
for(var i = 0; i < INPUT_CLUSTER._Length; i++)
{
	global.controlClustX[i] = InputX(i);
	global.controlClustY[i] = InputY(i);
	global.controlDirection[i] = InputDirection(0, i);
	global.controlDistance[i] = InputDistance(i);
}
