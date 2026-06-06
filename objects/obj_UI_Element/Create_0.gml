/*
active = true;

width = 0;
height = 0;

page = noone;
containerEle = noone;
nestedEle = [];
selectedEle = noone;
#region Element create functions

function CreateUIPanel(_objInd = obj_UI_Panel, _x, _y, _width, _height, _text = [], _scrollWidth = 0, _scrollHeight = 0, _scrollX = 0, _scrollY = 0)
{
	///@param objIndex=obj_UI_Panel
	///@param x
	///@param y
	///@param width
	///@param height
	///@param rawText=StringOrArray
	///@param scrollWidth=0
	///@param scrollHeight=0
	///@param scrollX=0
	///@param scrollY=0
	
	var pnl = page.CreateUIPanel(_objInd, _x, _y, _width, _height, _text, _scrollWidth, _scrollHeight, _scrollX, _scrollY);
	pnl.containerEle = id;
	selectedEle = (selectedEle == noone) ? pnl : selectedEle;
	
	array_push(nestedEle, pnl);
	
	return pnl;
}
function CreateUIButton(_objInd = obj_UI_Button, _x, _y, _width, _height, _text = [])
{
	///@param objIndex=obj_UI_Button
	///@param x
	///@param y
	///@param width
	///@param height
	///@param rawText=StringOrArray
	
	var btn = page.CreateUIButton(_objInd, _x, _y, _width, _height, _text);
	btn.containerEle = id;
	selectedEle = (selectedEle == noone) ? btn : selectedEle;
	
	array_push(nestedEle, btn);
	
	return btn;
}
function CreateUICycleButton(_objInd = obj_UI_CycleButton, _x, _y, _width, _height, _text = [])
{
	///@param objIndex=obj_UI_CycleButton
	///@param x
	///@param y
	///@param width
	///@param height
	///@param rawText=StringOrArray
	
	var btn = page.CreateUICycleButton(_objInd, _x, _y, _width, _height, _text);
	btn.containerEle = id;
	selectedEle = (selectedEle == noone) ? btn : selectedEle;
	
	array_push(nestedEle, btn);
	
	return btn;
}
function CreateUITextElement(_objInd = obj_UI_TextElement, _x, _y, _width, _height, _text = [])
{
	///@param objIndex=obj_UI_TextElement
	///@param x
	///@param y
	///@param width
	///@param height
	///@param rawText=StringOrArray
	
	var txt = page.CreateUITextElement(_objInd, _x, _y, _width, _height, _text);
	txt.containerEle = id;
	selectedEle = (selectedEle == noone) ? txt : selectedEle;
	
	array_push(nestedEle, txt);
	
	return txt;
}

#endregion
#region Modal functions

function SetModal()
{
	if(instance_exists(page) && array_find_index_by_value(page.modalElements, id) == -1)
	{
		array_push(page.modalElements, id);
	}
}
function UnsetModal()
{
	var _ind = array_find_index_by_value(page.modalElements, id);
	if(instance_exists(page) && _ind != -1)
	{
		array_delete(page.modalElements, _ind, 1);
	}
}
function IsModal()
{
	return (instance_exists(page) && array_find_index_by_value(page.modalElements, id) != -1);
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

posX = 0;
posY = 0;
scrollPosX = 0;
scrollPosY = 0;
#region GetX
function GetX()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return scr_round(containerEle.posX + x - containerEle.scrollPosX);
	}
	if(instance_exists(page))
	{
		return scr_round(page.x + x);
	}
	return -1000;
}
#endregion
#region GetY
function GetY()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return scr_round(containerEle.posY + y - containerEle.scrollPosY);
	}
	if(instance_exists(page))
	{
		return scr_round(page.y + y);
	}
	return -1000;
}
#endregion
function UpdatePosVars()
{
	posX = self.GetX();
	posY = self.GetY();
}

isMouseHovering = false;
containMouseCol = true;
#region IsMouseHovering
function IsMouseHovering()
{
	if(instance_exists(obj_Mouse))
	{
		var _x = posX,
			_y = posY;
		
		var _flag = true;
		if(containMouseCol && containerEle != noone && instance_exists(containerEle))
		{
			_flag = containerEle.isMouseHovering;
		}
		
		if(_flag)
		{
			if(mask_index != -1)
			{
				return place_meeting(_x, _y, obj_Mouse);
			}
			
			var eleL = min(_x, _x+width),
				eleR = max(_x, _x+width),
				eleT = min(_y, _y+height),
				eleB = max(_y, _y+height);
			with(obj_Mouse)
			{
				return (bbox_left >= eleL && bbox_right <= eleR && bbox_top >= eleT && bbox_bottom <= eleB);
			}
		}
	}
	return false;
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
	if(instance_exists(containerEle) && (containerEle.object_index == obj_UI_Panel || object_is_ancestor(containerEle.object_index,obj_UI_Panel)))
	{
		
	}
	
	audio_stop_sound(snd_MenuTick);
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
	
	//if(canMouseSelect || mouseOnly)
	//{
		isMouseHovering = self.IsMouseHovering();
	//}
	
	if(justSelected)
	{
		justSelected = false;
		exit;
	}
	
	if(self.PreUpdate())
	{
		if(mouseOnly)
		{
			if(isMouseHovering)
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
			if(isMouseHovering && (obj_Mouse.velX != 0 || obj_Mouse.velY != 0))
			{
				page.SelectElement(id);
			}
		}
		
		if(array_length(nestedEle) > 0)
		{
			for(var i = array_length(nestedEle)-1; i >= 0; i--)
			{
				if(i >= array_length(nestedEle)) continue;
				
				var ele = nestedEle[i];
				if(instance_exists(ele))
				{
					ele.UpdatePosVars();
					if(ele.active)
					{
						ele.UpdateElement();
					}
				}
			}
		}
	}
	
	self.PostUpdate();
}
function PostUpdate() {}

#endregion

#region Text

rawText = [];
text = [""];
updateText = true;
function _GetText()
{
	if(updateText || obj_UI_Controller.updateText)
	{
		for(var i = 0; i < array_length(rawText); i++)
		{
			text[i] = UI_InsertIconsIntoString(rawText[i]);
		}
		updateText = false;
	}
	return text;
}
function GetText()
{
	return self._GetText()[0];
}

textFont = fnt_GUI;
textColor = c_white;
textAlignX = fa_center;
textAlignY = fa_middle;
useScribDeluxe = false;

function DrawText(_color, _alignOffX = 4, _alignOffY = 2)
{
	var _x = posX,
		_y = posY,
		_alph = alpha,
		_text = self.GetText();
	
	if(is_string(_text) && _text != "")
	{
		var _aOffX = width/2;
		if(textAlignX == fa_left) { _aOffX = _alignOffX; }
		if(textAlignX == fa_right) { _aOffX = -_alignOffX; }
		var _aOffY = height/2;
		if(textAlignY == fa_top) { _aOffY = _alignOffY; }
		if(textAlignY == fa_bottom) { _aOffY = -_alignOffY; }
		
		if(useScribDeluxe)
		{
			var _scrib = scribble(_text)
				.starting_format(font_get_name(textFont), _color)
				.align(textAlignX,textAlignY);
			
			draw_scribble_shadow(_scrib, floor(_x+_aOffX), floor(_y+_aOffY+1), _color, _alph, , _alph);
		}
		else
		{
			var _scribJr = ScribbleJr(_text, textAlignX, textAlignY, textFont);
			
			draw_ScribbleJr_shadow(_scribJr, floor(_x+_aOffX), floor(_y+_aOffY+1), _color, _alph, , _alph);
		}
	}
}

#endregion

containDraw = true;
#region Draw functions

alpha = 1;
function GetAlpha()
{
	if(containerEle != noone && instance_exists(containerEle))
	{
		return image_alpha * containerEle.alpha;
	}
	return image_alpha * page.alpha;
}

function PreDraw() { return true; }
function DrawElement()
{
	if(!instance_exists(creatorUI)) exit;
	if(!instance_exists(page)) exit;
	if(containerEle != noone && !instance_exists(containerEle)) exit;
	
	alpha = self.GetAlpha();
	
	var _scis = gpu_get_scissor();
	if(containDraw && containerEle != noone)
	{
		gpu_set_scissor(containerEle.posX, containerEle.posY, containerEle.width, containerEle.height);
	}
	else if(!containDraw)
	{
		gpu_set_scissor(0,0,global.resWidth,global.resHeight);
	}
	
	if(self.PreDraw())
	{
		var _size = array_length(nestedEle);
		if(_size > 0)
		{
			for(var i = 0; i < _size; i++)
			{
				var _ele = nestedEle[i];
				if(instance_exists(_ele))
				{
					_ele.DrawElement();
				}
			}
		}
	}
	self.PostDraw();
	
	gpu_set_scissor(_scis);
}
function PostDraw() {}

#endregion
*/