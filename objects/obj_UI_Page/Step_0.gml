/// @description 

if(!instance_exists(creatorUI))
{
	instance_destroy();
	exit;
}

if(active)
{
	alpha = min(alpha+alphaRate,1);
}
else
{
	alpha = max(alpha-alphaRate,0);
	if(alpha <= 0)
	{
		instance_destroy();
		exit;
	}
}

x = global.resWidth/2 + xOffset;
y = global.resHeight/2 + yOffset;