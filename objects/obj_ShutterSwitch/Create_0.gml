/// @description 
event_inherited();
lhc_activate();

image_index = 0;
image_speed = 0;

shutterID = 0;

lastProj = noone;

function Toggle()
{
	var num = instance_number(obj_ShutterGate);
	for(var i = 0; i < num; i++)
	{
		var sGate = instance_find(obj_ShutterGate,i);
		if(instance_exists(sGate) && sGate.shutterID == shutterID)
		{
			sGate.Toggle();
		}
	}
}