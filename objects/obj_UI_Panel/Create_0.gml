/// @description 
event_inherited();

scrollWidth = 0;
scrollHeight = 0;
scrollStepX = 16;
scrollStepY = 16;

scrollBarThickness = 7;
scrollBarEndPad = 1;
scrollBarSidePad = 1;

horiScrollBarHeld = false;
horiScrollBarHover = false;
horiScrollBarMouseXOffset = 0;
vertScrollBarHeld = false;
vertScrollBarHover = false;
vertScrollBarMouseYOffset = 0;

function PreUpdate()
{
	if(scrollWidth == -1 || scrollHeight == -1)
	{
		var _scrWidth = max(scrollWidth, width),
			_scrHeight = max(scrollHeight, height);
		
		var _size = array_length(nestedEle);
		if(_size > 0)
		{
			for(var i = 0; i < _size; i++)
			{
				var ele = nestedEle[i];
				_scrWidth = max(_scrWidth, ele.x+ele.width+16);
				_scrHeight = max(_scrHeight, ele.y+ele.height+16);
			}
		}
		
		scrollWidth = (scrollWidth == -1) ? _scrWidth : scrollWidth;
		scrollHeight = (scrollHeight == -1) ? _scrHeight : scrollHeight;
	}
	
	if(scrollWidth > width || scrollHeight > height)
	{
		if(self.IsSelected())
		{
			var _mouse = obj_Mouse;
			if(scrollWidth > width)
			{
				var _scrollScale = width / scrollWidth,
					_barWidth = width * _scrollScale,
					_barXOffset = scrollPosX * _scrollScale,
					_thick = scrollBarThickness,
					_pad = scrollBarEndPad,
					_sPad = scrollBarSidePad;
				if(instance_exists(_mouse))
				{
					horiScrollBarHover = instance_exists(collision_rectangle(x+_pad, y+height-_thick-_sPad, x+width-_pad, y+height-_sPad, _mouse, false, true));
					if(creatorUI.cClickL && creatorUI.rClickL && horiScrollBarHover)
					{
						horiScrollBarHeld = true;
					}
					else if(!creatorUI.cClickL && creatorUI.rClickL)
					{
						horiScrollBarHeld = false;
					}
					
					if(horiScrollBarHeld)
					{
						scrollPosX = ((_mouse.x-(x+_pad)) / _scrollScale) - horiScrollBarMouseXOffset;
					}
					else
					{
						horiScrollBarMouseXOffset = ((_mouse.x-(x+_pad)) / _scrollScale) - scrollPosX;
					}
				}
				
				var moveX = creatorUI.ScrollX();
				scrollPosX += scrollStepX*moveX;
			}
			if(scrollHeight > height)
			{
				var _scrollScale = height / scrollHeight,
					_barHeight = height * _scrollScale,
					_barYOffset = scrollPosY * _scrollScale,
					_thick = scrollBarThickness,
					_pad = scrollBarEndPad,
					_sPad = scrollBarSidePad;
				if(instance_exists(_mouse))
				{
					vertScrollBarHover = instance_exists(collision_rectangle(x+width-_thick-_sPad, y+_pad, x+width-_sPad, y+height-_pad, _mouse, false, true));
					if(creatorUI.cClickL && creatorUI.rClickL && vertScrollBarHover)
					{
						vertScrollBarHeld = true;
					}
					else if(!creatorUI.cClickL && creatorUI.rClickL)
					{
						vertScrollBarHeld = false;
					}
					
					if(vertScrollBarHeld)
					{
						scrollPosY = ((_mouse.y-(y+_pad)) / _scrollScale) - vertScrollBarMouseYOffset;
					}
					else
					{
						vertScrollBarMouseYOffset = ((_mouse.y-(y+_pad)) / _scrollScale) - scrollPosY;
					}
				}
				
				var moveY = creatorUI.ScrollY();
				scrollPosY += scrollStepY*moveY;
			}
		}
	}
	
	scrollPosX = clamp(scrollPosX, 0, max(scrollWidth-width, 0));
	scrollPosY = clamp(scrollPosY, 0, max(scrollHeight-height, 0));
	
	return true;
}

function DrawScrollBars()
{
	if(scrollWidth > width || scrollHeight > height)
	{
		var _x = posX,
			_y = posY,
			_alph = alpha;
		
		if(scrollWidth > width)
		{
			var _scrollScale = width / scrollWidth,
				_barWidth = width * _scrollScale,
				_barXOffset = scrollPosX * _scrollScale,
				_thick = scrollBarThickness,
				_pad = scrollBarEndPad,
				_sPad = scrollBarSidePad;
			
			draw_sprite_stretched_ext(sprt_UI_Scrollbar, 0, x+_pad, y+height-_thick-_sPad, width-_pad*2,_thick, c_white, _alph);
			var imgInd = 1;
			if(horiScrollBarHover || horiScrollBarHeld)
			{
				imgInd = 2;
			}
			draw_sprite_stretched_ext(sprt_UI_Scrollbar, imgInd, x+_pad+_barXOffset, y+height-_thick-_sPad, _barWidth-_pad*2, _thick, c_white, _alph);
		}
		if(scrollHeight > height)
		{
			var _scrollScale = height / scrollHeight,
				_barHeight = height * _scrollScale,
				_barYOffset = scrollPosY * _scrollScale,
				_thick = scrollBarThickness,
				_pad = scrollBarEndPad,
				_sPad = scrollBarSidePad;
			
			draw_sprite_stretched_ext(sprt_UI_Scrollbar, 0, x+width-_thick-_sPad, y+_pad, _thick, height-_pad*2, c_white, _alph);
			var imgInd = 1;
			if(vertScrollBarHover || vertScrollBarHeld)
			{
				imgInd = 2;
			}
			draw_sprite_stretched_ext(sprt_UI_Scrollbar, imgInd, x+width-_thick-_sPad, y+_pad+_barYOffset, _thick, _barHeight-_pad*2, c_white, _alph);
		}
	}
}
function PreDraw()
{
	self.DrawScrollBars();
	
	return true;
}