/// @description 

active = true;

width = 0;
height = 0;

alpha = 1;

text = "";

creator = noone;
panel = noone;

button_up = noone;
button_down = noone;
button_left = noone;
button_right = noone;

function SelectControlVert()
{
	return (creator.cDown && creator.rDown) - (creator.cUp && creator.rUp);
}
function SelectControlHori()
{
	return (creator.cRight && creator.rRight) - (creator.cLeft && creator.rLeft);
}

function GetX() { return panel.x + (x + panel.scrollPosX) * panel.scaleX; }
function GetY() { return panel.y + (y + panel.scrollPosY) * panel.scaleY; }

function GetMouse()
{
	var _x = GetX(),
		_y = GetY();
	var mouse = noone;
	if(mask_index != -1)
	{
		mouse = instance_place(_x, _y, obj_Mouse);
	}
	else
	{
		mouse = collision_rectangle(_x, _y, _x+width*image_xscale, _y+height*image_yscale, obj_Mouse, true, true);
	}
	if(instance_exists(mouse) && mouse.x == clamp(mouse.x, panel.x, panel.x+panel.width*panel.scaleX) && mouse.y == clamp(mouse.y, panel.y, panel.y+panel.height*panel.scaleY))
	{
		return mouse;
	}
	
	return noone;
}

function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}

function WhileSelected()
{
	var mouse = GetMouse();
	if((creator.cSelect && creator.rSelect) || (instance_exists(mouse) && creator.cClickL && creator.rClickL))
	{
		OnClick();
	}
}

function OnClick()
{
	audio_play_sound(snd_MenuBoop,0,false);
}

function ChangeSelection(newBtn, moveFlag)
{
	if(instance_exists(newBtn) && newBtn.active && newBtn.panel.active && moveFlag)
	{
		creator.selectedPanel = newBtn.panel;
		newBtn.panel.selectedButton = newBtn;
		newBtn.OnSelect();
		newBtn.justSelected = true;
	}
}

justSelected = false;
function UpdateButton()
{
	if(justSelected)
	{
		justSelected = false;
		exit;
	}
	
	var mouse = GetMouse();
	
	if(creator.selectedPanel == panel)
	{
		if(panel.selectedButton == id)
		{
			WhileSelected();
		
			var moveY = SelectControlVert(),
				moveX = SelectControlHori();
			ChangeSelection(button_up, (moveY < 0));
			ChangeSelection(button_down, (moveY > 0));
			ChangeSelection(button_left, (moveX < 0));
			ChangeSelection(button_right, (moveX > 0));
		}
		else
		{
			if(instance_exists(mouse) && (mouse.velX != 0 || mouse.velY != 0))
			{
				panel.selectedButton = id;
				OnSelect();
				justSelected = true;
			}
		}
	}
}

buttonSurf = noone;
function DrawButton(_x, _y)
{
	
}