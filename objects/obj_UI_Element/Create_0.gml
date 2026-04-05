
active = true;

width = 0;
height = 0;

page = noone;
containerEle = noone;
nestedEle = ds_list_create();
selectedEle = noone;
#region Element create functions

function CreateUIPanel(_objInd = obj_UI_Panel, _x, _y, _width, _height, _scrollWidth = 0, _scrollHeight = 0, _scrollX = 0, _scrollY = 0)
{
	var pnl = page.CreateUIPanel(_objInd, _x, _y, _width, _height, _scrollWidth, _scrollHeight, _scrollX, _scrollY);
	pnl.containerEle = id;
	selectedEle = (selectedEle == noone) ? pnl : selectedEle;
	ds_list_add(nestedEle, pnl);
	return pnl;
}
function CreateUIButton(_objInd = obj_UI_Button, _x, _y, _width, _height, _text = "")
{
	var btn = page.CreateUIButton(_objInd, _x, _y, _width, _height, _text);
	btn.containerEle = id;
	selectedEle = (selectedEle == noone) ? btn : selectedEle;
	ds_list_add(nestedEle, btn);
	return btn;
}
function CreateUICycleButton(_objInd = obj_UI_CycleButton, _x, _y, _width, _height, _text = [""])
{
	var btn = page.CreateUICycleButton(_objInd, _x, _y, _width, _height, _text);
	btn.containerEle = id;
	selectedEle = (selectedEle == noone) ? btn : selectedEle;
	ds_list_add(nestedEle, btn);
	return btn;
}
function CreateUITextElement(_objInd = obj_UI_TextElement, _x, _y, _width, _height, _text = "")
{
	var txt = page.CreateUITextElement(_objInd, _x, _y, _width, _height, _text);
	txt.containerEle = id;
	selectedEle = (selectedEle == noone) ? txt : selectedEle;
	ds_list_add(nestedEle, txt);
	return txt;
}

#endregion
#region Modal functions

function SetModal()
{
	if(instance_exists(page) && ds_exists(page.modalElements,ds_type_list) && ds_list_find_index(page.modalElements,id) == -1)
	{
		ds_list_add(page.modalElements,id);
	}
}
function UnsetModal()
{
	if(instance_exists(page) && ds_exists(page.modalElements,ds_type_list))
	{
		var pos = ds_list_find_index(page.modalElements,id);
		ds_list_delete(page.modalElements,pos);
	}
}
function IsModal()
{
	return (instance_exists(page) && ds_exists(page.modalElements,ds_type_list) && ds_list_find_index(page.modalElements,id) != -1);
}

#endregion
#region IsSelected
function IsSelected()
{
	if(instance_exists(containerEle))
	{
		return (containerEle.selectedEle == id && containerEle.IsSelected());
	}
	return (instance_exists(page) && page.selectedEle == id);
}
#endregion

scrollPosX = 0;
scrollPosY = 0;
#region GetX
function GetX()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return containerEle.GetX() + x + containerEle.scrollPosX;
	}
	if(instance_exists(page))
	{
		return page.x + x;
	}
	return -1000;
}
#endregion
#region GetY
function GetY()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return containerEle.GetY() + y + containerEle.scrollPosY;
	}
	if(instance_exists(page))
	{
		return page.y + y;
	}
	return -1000;
}
#endregion

containMouseCol = true;
#region GetMouse
function GetMouse()
{
	var _x = self.GetX(),
		_y = self.GetY();
	
	if(containMouseCol && containerEle != noone && instance_exists(containerEle))
	{
		var mouse = containerEle.GetMouse();
		var flag = false;
		if(mask_index != -1)
		{
			flag = place_meeting(_x, _y, mouse);
		}
		else
		{
			var eleL = min(_x, _x+width),
				eleR = max(_x, _x+width),
				eleT = min(_y, _y+height),
				eleB = max(_y, _y+height);
			flag = instance_exists(collision_rectangle(eleL, eleT, eleR-1, eleB-1, mouse, false, true));
		}
		if(instance_exists(mouse) && flag)
		{
			return mouse;
		}
	}
	
	if(mask_index != -1)
	{
		return instance_place(_x, _y, obj_Mouse);
	}
	
	var eleL = min(_x, _x+width),
		eleR = max(_x, _x+width),
		eleT = min(_y, _y+height),
		eleB = max(_y, _y+height);
	return collision_rectangle(eleL, eleT, eleR-1, eleB-1, obj_Mouse, true, true);
}
#endregion

element_up = noone;
element_down = noone;
element_left = noone;
element_right = noone;
#region SetNavElements
function SetNavElements(_up = undefined, _down = undefined, _left = undefined, _right = undefined)
{
	element_up = is_undefined(_up) ? element_up : _up;
	element_down = is_undefined(_down) ? element_down : _down;
	element_left = is_undefined(_left) ? element_left : _left;
	element_right = is_undefined(_right) ? element_right : _right;
}
#endregion

function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}
function WhileSelected() {}

canNavigate = false;
canMouseSelect = false;
mouseOnly = false;
#region Update functions

justSelected = false;
function PreUpdate() { return true; }
function UpdateElement()
{
	if(!instance_exists(creatorUI)) exit;
	if(!instance_exists(page)) exit;
	if(containerEle != noone && !instance_exists(containerEle)) exit;
	
	if(justSelected)
	{
		justSelected = false;
		exit;
	}
	
	if(self.PreUpdate())
	{
		if(mouseOnly)
		{
			if(instance_exists(self.GetMouse()))
			{
				self.WhileSelected();
			}
		}
		else if(self.IsSelected())
		{
			if(canNavigate)
			{
				var moveX = creatorUI.MoveSelectX(),
					moveY = creatorUI.MoveSelectY();
				if(moveX < 0) { page.SelectElement(element_left); }
				if(moveX > 0) { page.SelectElement(element_right); }
				if(moveY < 0) { page.SelectElement(element_up); }
				if(moveY > 0) { page.SelectElement(element_down); }
			}
			
			self.WhileSelected();
		}
		else if(canMouseSelect)
		{
			var mouse = self.GetMouse();
			if(instance_exists(mouse) && (mouse.velX != 0 || mouse.velY != 0))
			{
				page.SelectElement(id);
			}
		}
		
		if(ds_exists(nestedEle, ds_type_list) && ds_list_size(nestedEle) > 0)
		{
			for(var i = ds_list_size(nestedEle)-1; i >= 0; i--)
			{
				var ele = nestedEle[| i];
				if(instance_exists(ele) && ele.active)
				{
					ele.UpdateElement();
				}
				if(!ds_exists(nestedEle, ds_type_list))
				{
					break;
				}
			}
		}
	}
	
	self.PostUpdate();
}
function PostUpdate() {}

#endregion

containDraw = true;
#region Draw functions

text = "";
function GetText() { return text; }

alpha = 1;
function GetAlpha()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return alpha * containerEle.GetAlpha();
	}
	return alpha * page.alpha;
}

function PreDraw() { return true; }
function DrawElement()
{
	if(!instance_exists(creatorUI)) exit;
	if(!instance_exists(page)) exit;
	if(containerEle != noone && !instance_exists(containerEle)) exit;
	
	var _x = self.GetX(),
		_y = self.GetY(),
		_scis = gpu_get_scissor();
	if(containDraw && containerEle != noone && instance_exists(containerEle))
	{
		gpu_set_scissor(containerEle.GetX(),containerEle.GetY(),containerEle.width,containerEle.height);
	}
	else if(!containDraw)
	{
		gpu_set_scissor(0,0,global.resWidth,global.resHeight);
	}
	
	if(self.PreDraw())
	{
		if(ds_list_size(nestedEle) > 0)
		{
			for(var i = 0; i < ds_list_size(nestedEle); i++)
			{
				var _ele = nestedEle[| i];
				if(instance_exists(_ele))
				{
					_ele.DrawElement();
				}
			}
		}
	}
	self.PostDraw();
	
	gpu_set_scissor(_scis);
	
	/*var _x = self.GetX(),
		_y = self.GetY();
	if(self.PreDraw())
	{
		if(ds_list_size(nestedEle) > 0)
		{
			var _scis = gpu_get_scissor();
			gpu_set_scissor(_x,_y,width,height);
			
			for(var i = 0; i < ds_list_size(nestedEle); i++)
			{
				var _ele = nestedEle[| i];
				if(instance_exists(_ele))
				{
					if(_ele.containDraw)
					{
						_ele.DrawElement();
					}
					else
					{
						gpu_set_scissor(0,0,global.resWidth,global.resHeight);
						_ele.DrawElement();
						gpu_set_scissor(_x,_y,width,height);
					}
				}
			}
			
			gpu_set_scissor(_scis);
		}
	}
	self.PostDraw();*/
}
function PostDraw() {}

#endregion
