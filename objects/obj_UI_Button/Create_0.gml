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

function GetX() { return panel.x + (x + panel.scrollPosX) * panel.scaleX; }
function GetY() { return panel.y + (y + panel.scrollPosY) * panel.scaleY; }

function GetMouse()
{
	var _x = self.GetX(),
		_y = self.GetY();
	var mouse = panel.GetMouse();
	var flag = false;
	if(mask_index != -1)
	{
		flag = place_meeting(_x, _y, mouse);
	}
	else
	{
		var btnL = min(_x, _x+width*image_xscale),
			btnR = max(_x, _x+width*image_xscale),
			btnT = min(_y, _y+height*image_yscale),
			btnB = max(_y, _y+height*image_yscale);
		flag = instance_exists(collision_rectangle(btnL, btnT, btnR, btnB, mouse, false, true));
	}
	if(instance_exists(mouse) && flag)
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
	var mouse = self.GetMouse();
	if((creator.cMenuAccept && creator.rMenuAccept) || (instance_exists(mouse) && creator.cClickL && creator.rClickL))
	{
		self.OnClick();
	}
}

function OnClick()
{
	audio_play_sound(snd_MenuBoop,0,false);
}

function ChangeSelection(newBtn, moveFlag)
{
	if(instance_exists(newBtn) && newBtn.active && instance_exists(newBtn.panel) && newBtn.panel.active && moveFlag)
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
	if(!instance_exists(creator))
	{
		instance_destroy();
		exit;
	}
	if(!instance_exists(panel))
	{
		instance_destroy();
		exit;
	}
	if(justSelected)
	{
		justSelected = false;
		exit;
	}
	
	var mouse = self.GetMouse();
	
	if(creator.selectedPanel == panel)
	{
		if(panel.selectedButton == id)
		{
			self.WhileSelected();
			
			if(instance_exists(panel))
			{
				var moveX = panel.MoveSelectX(),
					moveY = panel.MoveSelectY();
				self.ChangeSelection(button_left, (moveX < 0));
				self.ChangeSelection(button_right, (moveX > 0));
				self.ChangeSelection(button_up, (moveY < 0));
				self.ChangeSelection(button_down, (moveY > 0));
			}
		}
		else
		{
			if(instance_exists(mouse) && (mouse.velX != 0 || mouse.velY != 0))
			{
				panel.selectedButton = id;
				self.OnSelect();
				justSelected = true;
			}
		}
	}
}

buttonSurf = noone;
function DrawButton(_x, _y) {}