/// @description 
if(!init)
{
	gates = GetGates();
	for(var i = 0; i < array_length(gates); i++)
	{
		gateStartedOpen[i] = (gates[i].state == ShutterState.Opened || gates[i].state == ShutterState.Opening);
	}
	init = true;
}