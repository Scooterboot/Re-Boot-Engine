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

buttonScrib = scribble("btn");
buttonScrib.starting_format("fnt_GUI",c_white);
buttonScrib.align(fa_center,fa_middle);

function PreDraw()
{
	var _x = self.GetX(),
		_y = self.GetY();
	
	if(sprite_exists(bgSprt))
	{
		var _ind = bgSprtInd,
			_alph = bgAlpha * self.GetAlpha();
		if(self.IsSelected())
		{
			_ind = bgSelectSprtInd;
			_alph = bgSelectAlpha * self.GetAlpha();
		}
		
		var _ww = max(width, sprite_get_width(bgSprt)),
			_hh = max(height, sprite_get_height(bgSprt)),
			_xx = _x+width/2-_ww/2,
			_yy = _y+height/2-_hh/2;
		draw_sprite_stretched_ext(bgSprt,_ind, _xx,_yy, _ww,_hh, c_white,_alph);
	}
	else if(bgAlpha > 0)
	{
		var _alph = bgAlpha * self.GetAlpha(),
			_col = bgCol;
		if(self.IsSelected())
		{
			_alph = bgSelectAlpha * self.GetAlpha();
			_col = bgSelectCol;
		}
		if(_alph > 0)
		{
			draw_set_color(_col);
			draw_set_alpha(_alph);
			draw_rectangle(_x,_y, _x+width, _y+height, false);
			draw_set_color(c_white);
			draw_set_alpha(1);
		}
	}
	
	if(sprite_exists(sprt))
	{
		var _ind = sprtInd,
			_alph = sprtAlpha * self.GetAlpha();
		if(self.IsSelected())
		{
			_ind = sprtSelectInd;
			_alph = sprtSelectAlpha * self.GetAlpha();
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
