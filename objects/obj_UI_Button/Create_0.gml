/// @description 
event_inherited();

canNavigate = true;
canMouseSelect = true;

function OnClick()
{
	audio_play_sound(snd_MenuBoop,0,false);
}
function HotKey() { return false; }

function OnSelect()
{
	audio_play_sound(snd_MenuTick,0,false);
}
function WhileSelected()
{
	var mouse = self.GetMouse();
	if ((creatorUI.cMenuAccept && creatorUI.rMenuAccept && !mouseOnly) || 
		(instance_exists(mouse) && creatorUI.cClickL && creatorUI.rClickL))
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
	var _x = self.GetX(),
		_y = self.GetY(),
		_alph = self.GetAlpha();
	
	if(sprite_exists(bgSprt))
	{
		var _ind = bgSprtInd,
			_alph2 = bgAlpha * _alph;
		if(self.IsSelected())
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
		if(self.IsSelected())
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
		if(self.IsSelected())
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
