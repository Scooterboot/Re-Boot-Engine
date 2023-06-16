/// @description 
if(global.gamePaused)
{
	exit;
}

rot += 3;

x = xstart + lengthdir_x(64,rot);
y = ystart + lengthdir_y(64,rot);

//rot += 1.5;

//x = xstart + lengthdir_y(128,rot);
//y = ystart - lengthdir_y(64,rot*2);

//UpdatePositions();

for(var i = 0; i < array_length(mBlocks); i++)
{
	var xx = x + mBlockOffX[i],
		yy = y + mBlockOffY[i];
	mBlocks[i].UpdatePosition(xx,yy);
}