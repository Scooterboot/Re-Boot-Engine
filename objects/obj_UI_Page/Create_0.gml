
active = true;
alpha = 0;
alphaRate = 0.15;

xOffset = -global.resWidth/2;
yOffset = -global.resHeight/2;

elements = ds_list_create();
selectedEle = noone;
#region Element create functions

function CreateUIElement(_objInd, _x, _y, _width, _height)
{
	var ele = instance_create_depth(scr_floor(_x), scr_floor(_y), depth, _objInd, {creatorUI : creatorUI});
	ele.page = id;
	ele.width = scr_ceil(_width);
	ele.height = scr_ceil(_height);
	
	if(selectedEle == noone)
	{
		selectedEle = ele;
	}
	ds_list_add(elements, ele);
	return ele;
}
function CreateUIPanel(_objInd = obj_UI_Panel, _x, _y, _width, _height, _scrollWidth = 0, _scrollHeight = 0, _scrollX = 0, _scrollY = 0)
{
	var pnl = self.CreateUIElement(_objInd, _x, _y, _width, _height);
	pnl.scrollWidth = _scrollWidth;
	pnl.scrollHeight = _scrollHeight;
	pnl.scrollPosX = _scrollX;
	pnl.scrollPosY = _scrollY;
	return pnl;
}
function CreateUIButton(_objInd = obj_UI_Button, _x, _y, _width, _height, _text = "")
{
	var btn = self.CreateUIElement(_objInd, _x, _y, _width, _height);
	btn.text = _text;
	return btn;
}
function CreateUICycleButton(_objInd = obj_UI_CycleButton, _x, _y, _width, _height, _text = [""])
{
	var btn = self.CreateUIElement(_objInd, _x, _y, _width, _height);
	btn.cycleText = _text;
	return btn;
}
function CreateUITextElement(_objInd = obj_UI_TextElement, _x, _y, _width, _height, _text = "")
{
	var txt = self.CreateUIElement(_objInd, _x, _y, _width, _height);
	txt.text = _text;
	return txt;
}

#endregion
#region Modal functions

hasModalEle = false;
modalElements = ds_list_create();

function SetElementModal(_element)
{
	if(instance_exists(_element) && ds_exists(modalElements,ds_type_list) && ds_list_find_index(modalElements,_element) == -1)
	{
		ds_list_add(modalElements,_element);
	}
}
function UnsetElementModal(_element)
{
	if(instance_exists(_element) && ds_exists(modalElements,ds_type_list))
	{
		var pos = ds_list_find_index(modalElements,_element);
		ds_list_delete(modalElements,pos);
	}
}
function IsElementModal(_element)
{
	return (instance_exists(_element) && ds_exists(modalElements,ds_type_list) && ds_list_find_index(modalElements,_element) != -1);
}

#endregion
#region SelectElement
function SelectElement(_element, _onSelect = true)
{
	if(instance_exists(_element) && _element.active)
	{
		_element.justSelected = true;
		if(_onSelect) { _element.OnSelect(); }
		
		if(_element.containerEle == noone)
		{
			selectedEle = _element;
		}
		else if(instance_exists(_element.containerEle))
		{
			_element.containerEle.selectedEle = _element;
			self.SelectElement(_element.containerEle, false);
		}
	}
}
#endregion

#region Update functions

function PreUpdate() { return true; }
function UpdatePage()
{
	if(active)
	{
		if(self.PreUpdate())
		{
			hasModalEle = false;
			if(ds_list_size(modalElements) > 0)
			{
				for(var i = ds_list_size(modalElements)-1; i >= 0; i--)
				{
					var ele = modalElements[| i];
					if(instance_exists(ele) && ele.active)
					{
						ele.UpdateElement();
						hasModalEle = true;
						break;
					}
				}
			}
			
			if(!hasModalEle)
			{
				for(var i = ds_list_size(elements)-1; i >= 0; i--)
				{
					var ele = elements[| i];
					if(instance_exists(ele) && ele.active && ele.containerEle == noone)
					{
						ele.UpdateElement();
					
						if(self.IsElementModal(ele))
						{
							break;
						}
					}
					if(!ds_exists(elements, ds_type_list))
					{
						break;
					}
				}
			}
		}
		
		self.PostUpdate();
	}
}
function PostUpdate() {}

#endregion
#region Draw functions

function PreDraw() { return true; }
function DrawPage()
{
	if(self.PreDraw())
	{
		for(var i = 0; i < ds_list_size(elements); i++)
		{
			var ele = elements[| i];
			if(instance_exists(ele) && ele.containerEle == noone)
			{
				ele.DrawElement();
			}
		}
	}
	self.PostDraw();
}
function PostDraw() {}

#endregion
