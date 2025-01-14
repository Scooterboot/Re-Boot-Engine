/// @description 

active = true;

width = 0;
height = 0;

scrollWidth = 0;
scrollHeight = 0;

scrollPosX = 0;
scrollPosY = 0;
scrollStepX = 2;
scrollStepY = 2;

alpha = 1;
scaleX = 1;
scaleY = 1;

text = "";

creator = noone;
selectedButton = noone;
buttonList = ds_list_create();

function CreateButton(_x, _y, _width, _height, _text = "")
{
	var btn = instance_create_depth(_x, _y, depth, obj_UI_Button);
	btn.width = _width;
	btn.height = _height;
	btn.text = _text;
	btn.panel = id;
	btn.creator = creator;
	
	ds_list_add(buttonList, btn);
	return btn;
}

function ScrollMoveX()
{
	return 0;
}
function ScrollMoveY()
{
	return ((creator.cScrollDown && creator.rScrollDown) - (creator.cScrollUp && creator.rScrollUp));
}

function GetMouse()
{
	return collision_rectangle(x, y, x+width*scaleX, y+height*scaleY, obj_Mouse, true, true);
}

function UpdatePanel()
{
	var bNum = ds_list_size(buttonList);
	if(bNum > 0)
	{
		for(var i = 0; i < bNum; i++)
		{
			var _btn = buttonList[| i];
			if(selectedButton == noone)
			{
				selectedButton = _btn;
			}
			
			if(_btn.active)
			{
				_btn.UpdateButton();
			}
		}
	}
	
	if(creator.selectedPanel == id)
	{
		if(scrollWidth > width)
		{
			var moveX = ScrollMoveX();
			scrollPosX = clamp(scrollPosX + scrollStepX*moveX, 0, max(scrollWidth-width, 0));
		}
		if(scrollHeight > height)
		{
			var moveY = ScrollMoveY();
			scrollPosY = clamp(scrollPosY + scrollStepY*moveY, 0, max(scrollHeight-height, 0));
		}
	}
	else
	{
		var mouse = GetMouse();
		if(instance_exists(mouse) && (mouse.velX != 0 || mouse.velY != 0))
		{
			creator.selectedPanel = id;
		}
	}
}

panelSurf = noone;
function DrawPanel(_x, _y)
{
	
}