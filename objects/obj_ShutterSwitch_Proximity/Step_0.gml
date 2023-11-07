/// @description 
if(global.gamePaused)
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

var sGates = GetGates();
for(var i = 0; i < array_length(sGates); i++)
{
	if((playerDetected && 
		(sGates[i].state == ShutterState.Opened || sGates[i].state == ShutterState.Opening)) ||
	(!playerDetected && !stayClosed && 
		(sGates[i].state == ShutterState.Closed || sGates[i].state == ShutterState.Closing)))
	{
		sGates[i].Toggle(true);
	}
}