/// @description 

if(instance_exists(obj_Player))
{
	var player = obj_Player;
	
	active = true;
	
	if(facing == CamTileFacing.Right && player.x <= x+16)
	{
		active = false;
	}
	if(facing == CamTileFacing.Left && player.x >= x-16)
	{
		active = false;
	}
	if(facing == CamTileFacing.Down && player.y <= y+16)
	{
		active = false;
	}
	if(facing == CamTileFacing.Up && player.y >= y-16)
	{
		active = false;
	}
	
	var _num = instance_place_list(x,y,obj_CamScroll,scrollList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			var scroll = scrollList[| i];
			var flag = false;
			with(scroll)
			{
				if(place_meeting(x,y,player))
				{
					flag = true;
				}
			}
			if(flag)
			{
				active = false;
				break;
			}
		}
	}
	ds_list_clear(scrollList);
}