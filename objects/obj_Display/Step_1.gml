/// @description 

if(debug > 0)
{
	if(keyboard_check(vk_add))
	{
		if(!zoomTempFlag)
		{
			var zoomspd = 0.01;
			if(global.zoomScale > 1)
			{
				global.zoomScale = max(global.zoomScale-zoomspd,1);
				if(global.zoomScale <= 1)
				{
					zoomTempFlag = true;
				}
			}
			else
			{
				global.zoomScale = max(global.zoomScale-zoomspd,0.5);
			}
		}
	}
	else if(keyboard_check(vk_subtract))
	{
		if(!zoomTempFlag)
		{
			var zoomspd = 0.01;
			if(global.zoomScale < 1)
			{
				global.zoomScale = min(global.zoomScale+zoomspd,1);
				if(global.zoomScale >= 1)
				{
					zoomTempFlag = true;
				}
			}
			else
			{
				global.zoomScale = min(global.zoomScale+zoomspd,2);
			}
		}
	}
	else
	{
		zoomTempFlag = false;
	}
}
else
{
	global.zoomScale = 1;
}