/// @description 
//event_inherited();
if(global.gamePaused)
{
	exit;
}

if(instance_exists(creator) && creator.object_index == obj_Player)
{
	x += creator.position.X-creator.oldPosition.X;
	y += creator.position.Y-creator.oldPosition.Y;
	
	if(instance_exists(dist))
	{
		dist.left = x-20;
		dist.right = x+20;
		dist.top = y-20;
		dist.bottom = y+20;
	}
}

frameCounter++;
frame = frameSeq[min(frameCounter,array_length(frameSeq)-1)];
if(frameCounter >= array_length(frameSeq))
{
	instance_destroy();
}