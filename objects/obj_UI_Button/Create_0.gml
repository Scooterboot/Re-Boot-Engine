/// @description 
event_inherited();

canNavigate = true;
canMouseSelect = true;

function OnClick()
{
	audio_play_sound(snd_MenuBoop,0,false);
}
function HotKey() { return false; }
function HotKey_Cancel()
{
	return (creatorUI.cMenuCancel && creatorUI.rMenuCancel) || (creatorUI.cClickR && creatorUI.rClickR);
}

/*function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}*/
function WhileSelected()
{
	if ((creatorUI.cMenuAccept && creatorUI.rMenuAccept && !mouseOnly) || 
		(isMouseHovering && creatorUI.cClickL && creatorUI.rClickL))
	{
		self.OnClick();
	}
}

function PreUpdate()
{
	if(self.HotKey())
	{
		self.OnClick();
		return false;
	}
	return true;
}

bgSprt = noone;
bgSprtInd = 0;
bgAlpha = 0;
bgCol = c_black;
bgSelectSprtInd = 0;
bgSelectAlpha = 0;
bgSelectCol = c_white;

sprt = sprt_UI_Button;
sprtInd = 1;
sprtAlpha = 1;
sprtSelectInd = 0;
sprtSelectAlpha = 1;

function PreDraw()
{
	var _x = posX,
		_y = posY,
		_alph = alpha,
		_selected = self.IsSelected();
	
	if(sprite_exists(bgSprt))
	{
		var _ind = bgSprtInd,
			_alph2 = bgAlpha * _alph;
		if(_selected)
		{
			_ind = bgSelectSprtInd;
			_alph2 = bgSelectAlpha * _alph;
		}
		
		var _ww = max(width, sprite_get_width(bgSprt)),
			_hh = max(height, sprite_get_height(bgSprt)),
			_xx = _x+width/2-_ww/2,
			_yy = _y+height/2-_hh/2;
		draw_sprite_stretched_ext(bgSprt,_ind, _xx,_yy, _ww,_hh, c_white,_alph2);
	}
	else if(bgAlpha > 0)
	{
		var _alph2 = bgAlpha * _alph,
			_col = bgCol;
		if(_selected)
		{
			_alph2 = bgSelectAlpha * _alph;
			_col = bgSelectCol;
		}
		if(_alph2 > 0)
		{
			draw_set_color(_col);
			draw_set_alpha(_alph2);
			draw_rectangle(_x,_y, _x+width, _y+height, false);
			draw_set_color(c_white);
			draw_set_alpha(1);
		}
	}
	
	if(sprite_exists(sprt))
	{
		var _ind = sprtInd,
			_alph2 = sprtAlpha * _alph;
		if(_selected)
		{
			_ind = sprtSelectInd;
			_alph2 = sprtSelectAlpha * _alph;
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
