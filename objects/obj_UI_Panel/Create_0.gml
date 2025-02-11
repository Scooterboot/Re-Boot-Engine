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
	var btn = instance_create_depth(scr_floor(_x), scr_floor(_y), depth, obj_UI_Button);
	btn.width = scr_ceil(_width);
	btn.height = scr_ceil(_height);
	btn.text = _text;
	btn.panel = id;
	btn.creator = creator;
	
	ds_list_add(buttonList, btn);
	return btn;
}

function GetMouse()
{
	var panelL = min(x, x+width*scaleX),
		panelR = max(x, x+width*scaleX),
		panelT = min(y, y+height*scaleY),
		panelB = max(y, y+height*scaleY);
	return collision_rectangle(panelL, panelT, panelR, panelB, obj_Mouse, true, true);
}

function MoveSelectX()
{
	return (creator.cRight && creator.rRight) - (creator.cLeft && creator.rLeft);
}
function MoveSelectY()
{
	return (creator.cDown && creator.rDown) - (creator.cUp && creator.rUp);
}

function ScrollX()
{
	return 0;
}
function ScrollY()
{
	return ((creator.cScrollDown && creator.rScrollDown) - (creator.cScrollUp && creator.rScrollUp));
}

function UpdatePanel()
{
	for(var i = 0; i < ds_list_size(buttonList); i++)
	{
		var _btn = buttonList[| i];
		if(instance_exists(_btn))
		{
			if(!instance_exists(selectedButton))
			{
				selectedButton = _btn;
			}
			if(_btn.active)
			{
				_btn.UpdateButton();
			}
		}
		if(!ds_exists(buttonList, ds_type_list))
		{
			break;
		}
	}
	
	if(creator.selectedPanel == id)
	{
		if(scrollWidth > width)
		{
			var moveX = ScrollX();
			scrollPosX = clamp(scrollPosX + scrollStepX*moveX, 0, max(scrollWidth-width, 0));
		}
		if(scrollHeight > height)
		{
			var moveY = ScrollY();
			scrollPosY = clamp(scrollPosY + scrollStepY*moveY, 0, max(scrollHeight-height, 0));
		}
	}
	/*else
	{
		var mouse = GetMouse();
		if(instance_exists(mouse) && (mouse.velX != 0 || mouse.velY != 0))
		{
			creator.selectedPanel = id;
		}
	}*/
}

panelSurf = noone;
function DrawPanel(_x, _y)
{
	for(var i = 0; i < ds_list_size(buttonList); i++)
	{
		var btn = buttonList[| i];
		btn.DrawButton(btn.GetX(),btn.GetY());
	}
}