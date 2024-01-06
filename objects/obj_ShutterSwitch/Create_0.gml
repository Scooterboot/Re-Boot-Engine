/// @description 
event_inherited();
lhc_activate();

shutterID = 0;

frame = 2;
frameCounter = 0;
image_index = frame;
image_speed = 0;

init = false;

gates = array_create(0);

lastProj = noone;

function Toggle()
{
	for(var i = 0; i < array_length(gates); i++)
	{
		if(gates[i].state == ShutterState.Opening || (gates[i].state == ShutterState.Closing && !gates[i].stuck))
		{
			return;
		}
	}
	
	for(var i = 0; i < array_length(gates); i++)
	{
		gates[i].Toggle(gates[i].stuck);
	}
}