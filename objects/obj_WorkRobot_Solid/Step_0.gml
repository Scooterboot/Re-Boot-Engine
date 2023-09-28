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
	
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		mBlocks[i].isSolid = false;
	}
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		mBlocks[i].ignoredEntity = creator;
		
		if(i >= 3)
		{
			mBlockOffX[i] = mBlockOffX_default[i];
		
			var xdiff = x-creator.x;
		
			mBlockOffX[i] -= xdiff * ((i-3) / 6);
		}
		
		var xx = x + mBlockOffX[i],
			yy = y + mBlockOffY[i];
		mBlocks[i].UpdatePosition(xx,yy);
	}
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		mBlocks[i].isSolid = true;
	}
}
else
{
	instance_destroy();
	exit;
}

//UpdatePositions();