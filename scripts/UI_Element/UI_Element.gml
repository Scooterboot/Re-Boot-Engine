

function UI_Element(_creatorUI, _page, _x, _y, _width, _height, _rawText = []) constructor
{
	creatorUI = _creatorUI;
	page = _page;
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	rawText = [];
	if(is_string(_rawText))
	{
		rawText = [_rawText];
	}
	else if(is_array(_rawText))
	{
		rawText = _rawText;
	}
	
	active = true;
	
	containerEle = noone;
	nestedEle = [];
	selectedEle = noone;
	#region Element Create Functions
	
	static CreateUIPanel = function(_x, _y, _width, _height, _rawText = [], _scrollWidth = 0, _scrollHeight = 0, _scrollX = 0, _scrollY = 0)
	{
		///@param x
		///@param y
		///@param width
		///@param height
		///@param rawText=StringOrArray
		///@param scrollWidth=0
		///@param scrollHeight=0
		///@param scrollX=0
		///@param scrollY=0
		
		var pnl = page.CreateUIPanel(_x, _y, _width, _height, _rawText, _scrollWidth, _scrollHeight, _scrollX, _scrollY);
		pnl.containerEle = self;
		selectedEle = (selectedEle == noone) ? pnl : selectedEle;
		
		array_push(nestedEle, pnl);
		
		return pnl;
	}
	static CreateUIButton = function(_x, _y, _width, _height, _rawText = [])
	{
		///@param x
		///@param y
		///@param width
		///@param height
		///@param rawText=StringOrArray
	
		var btn = page.CreateUIButton(_x, _y, _width, _height, _rawText);
		btn.containerEle = self;
		selectedEle = (selectedEle == noone) ? btn : selectedEle;
	
		array_push(nestedEle, btn);
	
		return btn;
	}
	static CreateUICycleButton = function(_x, _y, _width, _height, _rawText = [])
	{
		///@param x
		///@param y
		///@param width
		///@param height
		///@param rawText=StringOrArray
	
		var btn = page.CreateUICycleButton(_x, _y, _width, _height, _rawText);
		btn.containerEle = self;
		selectedEle = (selectedEle == noone) ? btn : selectedEle;
	
		array_push(nestedEle, btn);
	
		return btn;
	}
	static CreateUITextElement = function(_x, _y, _width, _height, _rawText = [])
	{
		///@param x
		///@param y
		///@param width
		///@param height
		///@param rawText=StringOrArray
	
		var txt = page.CreateUITextElement(_x, _y, _width, _height, _rawText);
		txt.containerEle = self;
		selectedEle = (selectedEle == noone) ? txt : selectedEle;
	
		array_push(nestedEle, txt);
	
		return txt;
	}
	
	#endregion
	#region Modal functions
	
	static SetModal = function()
	{
		if(instance_exists(page) && array_find_index_by_value(page.modalElements, self) == -1)
		{
			array_push(page.modalElements, self);
		}
	}
	static UnsetModal = function()
	{
		var _ind = array_find_index_by_value(page.modalElements, self);
		if(instance_exists(page) && _ind != -1)
		{
			array_delete(page.modalElements, _ind, 1);
		}
	}
	static IsModal = function()
	{
		return (instance_exists(page) && array_find_index_by_value(page.modalElements, self) != -1);
	}
	
	#endregion
	#region IsSelected
	static IsSelected = function()
	{
		if(is_struct(containerEle))
		{
			return (containerEle.selectedEle == self && containerEle.IsSelected());
		}
		return (instance_exists(page) && page.selectedEle == self);
	}
	#endregion
	
	scrollPosX = 0;
	scrollPosY = 0;
	#region GetX
	static GetX = function()
	{
		if(containerEle != noone && is_struct(containerEle))
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
	posX = GetX();
	#region GetY
	static GetY = function()
	{
		if(containerEle != noone && is_struct(containerEle))
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
	posY = GetY();
	
	static UpdatePosVars = function()
	{
		posX = GetX();
		posY = GetY();
	}
	
	isMouseHovering = false;
	containMouseCheck = true;
	#region IsMouseHovering
	static IsMouseHovering = function()
	{
		if(instance_exists(obj_Mouse))
		{
			var _x = posX,
				_y = posY;
			
			var _flag = true;
			if(containMouseCheck && containerEle != noone && is_struct(containerEle))
			{
				_flag = containerEle.isMouseHovering;
			}
			
			if(_flag)
			{
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
	static SetNavElements = function(_up = undefined, _down = undefined, _left = undefined, _right = undefined)
	{
		element_up = is_undefined(_up) ? element_up : _up;
		element_down = is_undefined(_down) ? element_down : _down;
		element_left = is_undefined(_left) ? element_left : _left;
		element_right = is_undefined(_right) ? element_right : _right;
	}
	#endregion
	
	function OnSelect()
	{
		/*if(is_struct(containerEle) && (containerEle.object_index == obj_UI_Panel || object_is_ancestor(containerEle.object_index,obj_UI_Panel)))
		{
			
		}*/
		
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
	static UpdateElement = function()
	{
		if(!instance_exists(creatorUI)) exit;
		if(!instance_exists(page)) exit;
		if(containerEle != noone && !is_struct(containerEle)) exit;
		
		//if(canMouseSelect || mouseOnly)
		//{
			isMouseHovering = IsMouseHovering();
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
			else if(IsSelected())
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
					page.SelectElement(self);
				}
			}
			
			if(array_length(nestedEle) > 0)
			{
				for(var i = array_length(nestedEle)-1; i >= 0; i--)
				{
					if(i >= array_length(nestedEle)) continue;
					
					var ele = nestedEle[i];
					if(is_struct(ele))
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
	
	text = [""];
	updateText = true;
	static _GetText = function()
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
		return _GetText()[0];
	}
	
	#endregion
	#region Draw Text
	
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

	#region Draw functions
	
	image_alpha = 1;
	alpha = 1;
	function GetAlpha()
	{
		if(containerEle != noone && is_struct(containerEle))
		{
			return image_alpha * containerEle.alpha;
		}
		return image_alpha * page.alpha;
	}
	
	containDraw = true;
	
	function PreDraw() { return true; }
	static DrawElement = function()
	{
		if(!instance_exists(creatorUI)) exit;
		if(!instance_exists(page)) exit;
		if(containerEle != noone && !is_struct(containerEle)) exit;
		
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
					if(is_struct(_ele))
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
	
	#region CleanUp
	static CleanUp = function()
	{
		if(instance_exists(page))
		{
			var pos = array_find_index_by_value(page.modalElements, self);
			if(pos >= 0)
			{
				array_delete(page.modalElements, pos, 1);
			}
			
			pos = array_find_index_by_value(page.elements, self);
			if(pos >= 0)
			{
				array_delete(page.elements, pos, 1);
			}
		}
		
		if(is_struct(containerEle))
		{
			var pos = array_find_index_by_value(containerEle.nestedEle, self);
			if(pos >= 0)
			{
				array_delete(containerEle.nestedEle, pos, 1);
			}
		}
		for(var i = array_length(nestedEle)-1; i >= 0; i--)
		{
			if(is_struct(nestedEle[i]))
			{
				nestedEle[i].CleanUp();
				delete nestedEle[i];
			}
		}
	}
	#endregion
}