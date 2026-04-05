/// @description 
event_inherited();

scrollWidth = 0;
scrollHeight = 0;
scrollStepX = 2;
scrollStepY = 2;

function PreUpdate()
{
	if(scrollWidth == -1 || scrollHeight == -1)
	{
		var _scrWidth = max(scrollWidth, width),
			_scrHeight = max(scrollHeight, height);
		
		if(ds_exists(nestedEle, ds_type_list) && ds_list_size(nestedEle) > 0)
		{
			for(var i = ds_list_size(nestedEle)-1; i >= 0; i--)
			{
				var ele = nestedEle[| i];
				_scrWidth = max(_scrWidth, ele.x+ele.width);
				_scrHeight = max(_scrHeight, ele.x+ele.height);
			}
		}
		
		scrollWidth = (scrollWidth == -1) ? _scrWidth : scrollWidth;
		scrollHeight = (scrollHeight == -1) ? _scrHeight : scrollHeight;
	}
	
	if(scrollWidth > width || scrollHeight > height)
	{
		// TODO: better scrolling priority stuffs
		
		var selFlag = false;
		var mouse = self.GetMouse();
		/*if(instance_exists(mouse) && !mouse.hide)
		{
			selFlag = true;
		}
		else if(self.IsSelected())
		{
			selFlag = true;
		}*/
		/*if(!obj_Mouse.hide)
		{
			selFlag = instance_exists(mouse);
		}
		else
		{
			selFlag = self.IsSelected();
		}
		if(selFlag)*/
		if(self.IsSelected())
		{
			if(scrollWidth > width)
			{
				var moveX = creatorUI.ScrollX();
				scrollPosX += scrollStepX*moveX;
			}
			if(scrollHeight > height)
			{
				var moveY = creatorUI.ScrollY();
				scrollPosY += scrollStepY*moveY;
			}
		}
	}
	
	scrollPosX = clamp(scrollPosX, 0, max(scrollWidth-width, 0));
	scrollPosY = clamp(scrollPosY, 0, max(scrollHeight-height, 0));
	
	return true;
}
