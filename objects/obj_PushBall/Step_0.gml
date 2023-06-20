/// @description 

if(global.gamePaused)
{
	exit;
}

event_inherited();

for(var i = 0; i < array_length(mSlope); i++)
{
	if(instance_exists(mSlope[i]))
	{
		mSlope[i].UpdatePosition(position.X+mSlope_OffsetX[i],position.Y+mSlope_OffsetY[i]);
	}
}

if(fVelX != 0)
{
	rotation += point_direction(x,y,xprevious,bbox_bottom)+90;
}