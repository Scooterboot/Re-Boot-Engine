/// @description 
if(global.GamePaused())
{
	exit;
}

playerDetected = instance_exists(GetPlayer());
var num = instance_number(obj_ShutterSwitch_Proximity);
for(var i = 0; i < num; i++)
{
	var sSwitch = instance_find(obj_ShutterSwitch_Proximity,i);
	if(instance_exists(sSwitch) && sSwitch.id != id && sSwitch.shutterID == shutterID)
	{
		if(instance_exists(sSwitch.GetPlayer()))
		{
			playerDetected = true;
		}
	}
}

for(var i = 0; i < array_length(gates); i++)
{
	var toggleOpen = playerDetected,
		toggleClose = !playerDetected && !stayClosed;
	if(gates[i].initialState == ShutterState.Opened)
	{
		toggleOpen = !playerDetected && !stayClosed;
		toggleClose = playerDetected;
	}
	
	if((toggleClose && 
		(gates[i].state == ShutterState.Opened || gates[i].state == ShutterState.Opening)) ||
	(toggleOpen && 
		(gates[i].state == ShutterState.Closed || gates[i].state == ShutterState.Closing)))
	{
		gates[i].Toggle(true);
	}
}


frameCounter++;
if(frameCounter > 2)
{
	if(playerDetected)
	{
		frame = min(frame+1,5);
	}
	else
	{
		frame = max(frame-1,2);
	}
	frameCounter = 0;
}
if(frameFlicker)
{
	image_index = frame;
	frameFlicker = false;
}
else
{
	image_index = 2;
	frameFlicker = true;
}