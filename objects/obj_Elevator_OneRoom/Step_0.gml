/// @description 

if(!init && (!instance_exists(obj_Transition) || obj_Transition.transitionComplete))
{
	if(instance_exists(obj_Player) && obj_Player.bbox_bottom > y)
	{
		ele.y = bbox_bottom-15;
		ele.ystart = y;
		ele.upward = true;
		ele.downward = false;
	}
	
	init = true;
}

if(ele.y == ele.ystart)
{
	if(ele.downward)
	{
		ele.ystart = y;
	}
	else if(ele.upward)
	{
		ele.ystart = bbox_bottom-15;
	}
	
	ele.upward = !ele.upward;
	ele.downward = !ele.downward;
}