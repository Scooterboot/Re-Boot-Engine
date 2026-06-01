
active = true;
alpha = 0;
alphaRate = 0.15;

xOffset = -global.resWidth/2;
yOffset = -global.resHeight/2;

elements = [];
selectedEle = noone;
#region Element create functions

function CreateUIElement(_objInd, _x, _y, _width, _height, _rawText = [])
{
	///@param objIndex
	///@param x
	///@param y
	///@param width
	///@param height
	///@param rawText=StringOrArray
	
	var ele = instance_create_depth(scr_floor(_x), scr_floor(_y), depth, _objInd, {creatorUI : creatorUI});
	ele.UpdatePosVars();
	ele.page = id;
	ele.width = scr_ceil(_width);
	ele.height = scr_ceil(_height);
	if(is_string(_rawText))
	{
		ele.rawText = [_rawText];
	}
	else if(is_array(_rawText))
	{
		ele.rawText = _rawText;
	}
	
	if(selectedEle == noone)
	{
		selectedEle = ele;
	}
	array_push(elements, ele);
	
	return ele;
}
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
	
	var pnl = self.CreateUIElement(_objInd, _x, _y, _width, _height, _text);
	pnl.scrollWidth = _scrollWidth;
	pnl.scrollHeight = _scrollHeight;
	pnl.scrollPosX = _scrollX;
	pnl.scrollPosY = _scrollY;
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
	
	var btn = self.CreateUIElement(_objInd, _x, _y, _width, _height, _text);
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
	
	var btn = self.CreateUIElement(_objInd, _x, _y, _width, _height, _text);
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
	
	var txt = self.CreateUIElement(_objInd, _x, _y, _width, _height, _text);
	return txt;
}

#endregion
#region Modal functions

hasModalEle = false;
modalElements = [];

function SetElementModal(_element)
{
	if(instance_exists(_element) && array_find_index_by_value(modalElements, _element) == -1)
	{
		array_push(modalElements, _element);
	}
}
function UnsetElementModal(_element)
{
	var _ind = array_find_index_by_value(modalElements, _element);
	if(instance_exists(_element) && _ind != -1)
	{
		array_delete(modalElements, _ind, 1);
	}
}
function IsElementModal(_element)
{
	return (instance_exists(_element) && array_find_index_by_value(modalElements, _element) != -1);
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
			for(var i = 0, _size = array_length(elements); i < _size; i++)
			{
				var ele = elements[i];
				if(instance_exists(ele) && ele.containerEle == noone)
				{
					ele.UpdatePosVars();
				}
			}
			
			hasModalEle = false;
			if(array_length(modalElements) > 0)
			{
				for(var i = array_length(modalElements)-1; i >= 0; i--)
				{
					if(i >= array_length(modalElements)) continue;
					
					var ele = modalElements[i];
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
				for(var i = array_length(elements)-1; i >= 0; i--)
				{
					if(i >= array_length(elements)) continue;
					
					var ele = elements[i];
					if(instance_exists(ele) && ele.active && ele.containerEle == noone)
					{
						ele.UpdateElement();
					
						if(self.IsElementModal(ele))
						{
							break;
						}
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
		for(var i = 0, _size = array_length(elements); i < _size; i++)
		{
			var ele = elements[i];
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
