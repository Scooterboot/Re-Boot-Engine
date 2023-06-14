/// @description 
if(global.gamePaused)
{
	exit;
}

if(instance_exists(creator) && creator.object_index == obj_WorkRobot)
{
	x = creator.x;
	x += LerpArray(creator.topOffsetX,creator.frame-3,true) * creator.dir;
	y = creator.y;
	
	for(var i = 3; i < array_length(mBlocks); i++)
	{
		mBlockOffX[i] = mBlockOffX_default[i];
		
		var xdiff = x-creator.x;
		
		mBlockOffX[i] -= xdiff * ((i-3) / 6);
	}
}
else
{
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		instance_destroy(mBlocks[i]);
	}
	instance_destroy();
	exit;
}

UpdatePositions();