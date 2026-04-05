event_inherited();

canNavigate = true;
canMouseSelect = true;

cycleMode = false;
cycleText = [];
cycleClickRegionOffset = 0;
cycleClickRegionAxis = 0;

function GetCycleValue() { return 0; }
function OnCycle(_dir)
{
	audio_play_sound(snd_MenuTick,0,false);
}

function GetText()
{
	if(cycleMode)
	{
		return "< "+cycleText[self.GetCycleValue()]+" >";
	}
	return cycleText[self.GetCycleValue()];
}

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

buttonScrib = scribble("cycleBtn");
buttonScrib.starting_format("fnt_GUI",c_white);
buttonScrib.align(fa_center,fa_middle);

function PreDraw()
{
	var _x = self.GetX(),
		_y = self.GetY();
	
	if(sprite_exists(sprt))
	{
		var _ind = sprtInd,
			_alph = sprtAlpha * self.GetAlpha();
		if(self.IsSelected())
		{
			_ind = sprtSelectInd;
			_alph = sprtSelectAlpha * self.GetAlpha();
		}
		if(cycleMode)
		{
			_ind = sprtSelectInd2;
			_alph = sprtSelectAlpha2 * self.GetAlpha();
		}
		
		var _ww = max(width, sprite_get_width(sprt)),
			_hh = max(height, sprite_get_height(sprt)),
			_xx = _x+width/2-_ww/2,
			_yy = _y+height/2-_hh/2;
		draw_sprite_stretched_ext(sprt,_ind, _xx,_yy, _ww,_hh, c_white,_alph);
	}
	
	var _text = self.GetText();
	var _str = obj_UI_Icons.InsertIconsIntoString(_text);
	if(buttonScrib.get_text() != _str)
	{
		buttonScrib.overwrite(_str);
	}
	
	var xx = _x+width/2, yy = _y+height/2+1;
	buttonScrib.blend(c_black,self.GetAlpha());
	buttonScrib.draw(xx+1,yy+1);
	buttonScrib.blend(c_white,self.GetAlpha());
	buttonScrib.draw(xx,yy);
	
	return true;
}
