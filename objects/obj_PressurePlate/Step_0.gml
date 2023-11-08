/// @description 
if(global.gamePaused)
{
	exit;
}

entityDetected = instance_exists(GetEntity());
var num = instance_number(obj_PressurePlate);
for(var i = 0; i < num; i++)
{
	var pPlate = instance_find(obj_PressurePlate,i);
	if(instance_exists(pPlate) && pPlate.id != id && pPlate.shutterID == shutterID)
	{
		if(instance_exists(pPlate.GetEntity()))
		{
			entityDetected = true;
		}
	}
}

for(var i = 0; i < array_length(gates); i++)
{
	var toggleOpen = (entityDetected && !gateStartedOpen[i]) || (!entityDetected && gateStartedOpen[i]),
		toggleClose = (!entityDetected && !gateStartedOpen[i]) || (entityDetected && gateStartedOpen[i]);
	
	if((toggleClose && 
		(gates[i].state == ShutterState.Opened || gates[i].state == ShutterState.Opening)) ||
	(toggleOpen && 
		(gates[i].state == ShutterState.Closed || gates[i].state == ShutterState.Closing)))
	{
		gates[i].Toggle(true);
	}
}

if(entityDetected)
{
	frameCounter++;
	if(frameCounter > 2)
	{
		frame = min(frame+1,4);
		frameCounter = 0;
	}
}
else
{
	frameCounter++;
	if(frameCounter > 2)
	{
		frame = max(frame-1,0);
		frameCounter = 0;
	}
}
image_index = frame;