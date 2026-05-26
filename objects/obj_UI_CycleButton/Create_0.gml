event_inherited();

canNavigate = true;
canMouseSelect = true;

cycleMode = false;
cycleClickRegionOffset = 0;
cycleClickRegionAxis = 0;

//function GetCycleValue() { return 0; }
function OnCycle(_dir)
{
	audio_play_sound(snd_MenuTick,0,false);
}

/*function GetText()
{
	var cycleText = self._GetText();
	
	if(cycleMode)
	{
		return "< "+cycleText[self.GetCycleValue()]+" >";
	}
	return cycleText[self.GetCycleValue()];
}*/

function CycleInput()
{
	var _dir = 0;
	if(instance_exists(creatorUI))
	{
		_dir = sign(creatorUI.MoveSelectX(false) + (creatorUI.cMenuAccept && creatorUI.rMenuAccept));
	}
	return _dir;
}

function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}
function WhileSelected()
{
	if(!cycleMode)
	{
		var mouse = self.GetMouse();
		if ((creatorUI.cMenuAccept && creatorUI.rMenuAccept && !mouseOnly) || 
			(instance_exists(mouse) && creatorUI.cClickL && creatorUI.rClickL))
		{
			cycleMode = true;
			justSelected = true;
			self.SetModal();
			audio_play_sound(snd_MenuTick,0,false);
		}
	}
}

function PreUpdate()
{
	var mouse = self.GetMouse();
	if(cycleMode)
	{
		var cancel = ((creatorUI.cMenuCancel && creatorUI.rMenuCancel) || (creatorUI.cClickR && creatorUI.rClickR));
		
		var move = self.CycleInput();
		if(instance_exists(mouse) && creatorUI.cClickL && creatorUI.rClickL)
		{
			if(cycleClickRegionAxis == 0)
			{
				if(mouse.x < self.GetX() + floor(width/2) - cycleClickRegionOffset)
				{
					move = -1;
				}
				else if(mouse.x > self.GetX() + ceil(width/2) + cycleClickRegionOffset)
				{
					move = 1;
				}
			}
			else
			{
				if(mouse.y < self.GetY() + floor(height/2) - cycleClickRegionOffset)
				{
					move = -1;
				}
				else if(mouse.y > self.GetY() + ceil(height/2) + cycleClickRegionOffset)
				{
					move = 1;
				}
			}
		}
		else if(creatorUI.cClickL && creatorUI.rClickL)
		{
			cancel = true;
		}
		
		if(cancel)
		{
			cycleMode = false;
			justSelected = true;
			self.UnsetModal();
			audio_play_sound(snd_MenuTick,0,false);
		}
		else if(move != 0)
		{
			self.OnCycle(move);
		}
		
		return false;
	}
	
	return true;
}

sprt = sprt_UI_Button2;
sprtInd = 1;
sprtAlpha = 1;
sprtSelectInd = 0;
sprtSelectAlpha = 1;
sprtSelectInd2 = 3;
sprtSelectAlpha2 = 1;

function PreDraw()
{
	var _x = self.GetX(),
		_y = self.GetY(),
		_alph = self.GetAlpha();
	
	if(sprite_exists(sprt))
	{
		var _ind = sprtInd,
			_alph2 = sprtAlpha * _alph;
		if(self.IsSelected())
		{
			_ind = sprtSelectInd;
			_alph2 = sprtSelectAlpha * _alph;
		}
		if(cycleMode)
		{
			_ind = sprtSelectInd2;
			_alph2 = sprtSelectAlpha2 * _alph;
		}
		
		var _ww = max(width, sprite_get_width(sprt)),
			_hh = max(height, sprite_get_height(sprt)),
			_xx = _x+width/2-_ww/2,
			_yy = _y+height/2-_hh/2;
		draw_sprite_stretched_ext(sprt,_ind, _xx,_yy, _ww,_hh, c_white,_alph2);
	}
	
	var _text = self.GetText();
	var _scrib = scribble(_text)
		.starting_format(font_get_name(textFont),textColor)
		.align(textAlignX,textAlignY);
	
	var _alignOffX = width/2;
	if(textAlignX == fa_left) { _alignOffX = 4; }
	if(textAlignX == fa_right) { _alignOffX = -4; }
	var _alignOffY = height/2;
	if(textAlignY == fa_top) { _alignOffY = 2; }
	if(textAlignY == fa_bottom) { _alignOffY = -2; }
	
	draw_scribble_shadow(_scrib, _x+_alignOffX, _y+_alignOffY+1,textColor,_alph,,_alph);
	
	return true;
}
