/// @description 
if(global.gamePaused)
{
	exit;
}

//rot -= 2;

//x = xstart + lengthdir_x(64,rot);
//y = ystart + lengthdir_y(64,rot);

rot += 1;

x = xstart + lengthdir_y(128,rot);
y = ystart - lengthdir_y(64,rot*1.5);

for(var i = 0; i < array_length(blocks); i++)
{
	blocks[i].isSolid = false;
}
for(var i = array_length(blocks)-1; i >= 0; i--)
{
	var xx = x + blockOffX[i],
		yy = y + blockOffY[i];
	blocks[i].UpdatePosition(xx,yy);
}
for(var i = 0; i < array_length(blocks); i++)
{
	blocks[i].isSolid = true;
}

//posX = xstart + lengthdir_y(128,rot);
//posY = ystart - lengthdir_y(64,rot*1.5);
//isSolid = false;
//UpdatePosition(posX,posY);
//isSolid = true;