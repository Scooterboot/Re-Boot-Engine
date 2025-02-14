/// @description 
if(!init)
{
	var gnum = 0;
	var num = instance_number(obj_ShutterGate);
	for(var i = 0; i < num; i++)
	{
		var sGate = instance_find(obj_ShutterGate,i);
		if(instance_exists(sGate) && sGate.shutterID == shutterID)
		{
			gates[gnum] = sGate;
			gnum++;
		}
	}
	
	init = true;
}

if(toggled && !place_meeting(x,y,obj_Projectile))
{
	toggled = false;
}