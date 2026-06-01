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

/*function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}*/
function WhileSelected()
{
	if(!cycleMode)
	{
		if ((creatorUI.cMenuAccept && creatorUI.rMenuAccept && !mouseOnly) || 
			(isMouseHovering && creatorUI.cClickL && creatorUI.rClickL))
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
	if(cycleMode)
	{
		var cancel = ((creatorUI.cMenuCancel && creatorUI.rMenuCancel) || (creatorUI.cClickR && creatorUI.rClickR));
		
		var move = self.CycleInput();
		if(isMouseHovering && creatorUI.cClickL && creatorUI.rClickL)
		{
			if(cycleClickRegionAxis == 0)
			{
				if(obj_Mouse.x < self.posX + floor(width/2) - cycleClickRegionOffset)
				{
					move = -1;
				}
				else if(obj_Mouse.x > self.posX + ceil(width/2) + cycleClickRegionOffset)
				{
					move = 1;
				}
			}
			else
			{
				if(obj_Mouse.y < self.posY + floor(height/2) - cycleClickRegionOffset)
				{
					move = -1;
				}
				else if(obj_Mouse.y > self.posY + ceil(height/2) + cycleClickRegionOffset)
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
	var _x = posX,
		_y = posY,
		_alph = alpha;
	
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
	
	self.DrawText(textColor);
	
	return true;
}
