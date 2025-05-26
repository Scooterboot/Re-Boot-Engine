/// @description 

if(!instance_exists(lastProj))
{
	lastProj = noone;
}

var animFlag = false;
for(var i = 0; i < array_length(gates); i++)
{
	if(gates[i].initialState == ShutterState.Opened)
	{
		animFlag = (gates[i].state == ShutterState.Closed || gates[i].state == ShutterState.Closing);
	}
	else
	{
		animFlag = (gates[i].state == ShutterState.Opened || gates[i].state == ShutterState.Opening);
	}
	if(!animFlag)
	{
		break;
	}
}

frameCounter++;
if(frameCounter > 2)
{
	if(animFlag)
	{
		frame = min(frame+1,5);
	}
	else
	{
		frame = max(frame-1,2);
	}
	frameCounter = 0;
}
image_index = frame;