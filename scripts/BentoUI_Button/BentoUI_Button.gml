function BentoUI_Button(_clickFunc = undefined, _width, _height, _rawText = [], _creatorUI, _parent = other) : BentoUI_Element(_width, _height, _rawText, _creatorUI, _parent) constructor
{
	if (is_undefined(_clickFunc))
    {
        _clickFunc = function()
        {
            show_debug_message($"Button {string_delete(string(ptr(self)), 1, 8)} clicked");
        }
    }
	
	func = method(self, _clickFunc);
	
	BentoSetButton(BENTO_BUTTON_ALWAYS);
	
	hotKey = function() { return false; }
	hotKey_cancel = function()
	{
		if(BentoHotkeyGetPress(BENTO_HOTKEY_CANCEL) && !BentoHotkeyGetHold(BENTO_HOTKEY_CANCEL))
		{
			BentoInputConsume();
			return true;
		}
		return false;
	}
	
	onSelect = function()
	{
		audio_stop_sound(snd_MenuTick);
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	ignoreAnim = false;
	
	eventStep = function()
	{
		if (BentoPrimaryGetClick() || hotKey())
		{
			if (is_callable(func) && (!BentoAnimGetPlaying() || ignoreAnim))
			{
				func();
			}
		}
		if(BentoCursorGetEnterByPlayer())
		{
			onSelect();
		}
	}
	
	sprt = sprt_UI_Button;
	sprtInd = 1;
	sprtAlpha = 1;
	sprtSelectInd = 0;
	sprtSelectAlpha = 1;
	
	eventDraw = function()
	{
		var _x = bentoLeft,
			_y = bentoTop,
			_alph = image_alpha,
			_selected = BentoCursorGetHover();
		
		if(sprite_exists(sprt))
		{
			var _ind = sprtInd,
				_alph2 = sprtAlpha * _alph;
			if(_selected)
			{
				_ind = sprtSelectInd;
				_alph2 = sprtSelectAlpha * _alph;
			}
			
			var _ww = max(bentoWidth, sprite_get_width(sprt)),
				_hh = max(bentoHeight, sprite_get_height(sprt)),
				_xx = _x+bentoWidth/2-_ww/2,
				_yy = _y+bentoHeight/2-_hh/2;
			draw_sprite_stretched_ext(sprt,_ind, _xx,_yy, _ww,_hh, c_white,_alph2);
		}
		
		drawText(textColor);
	}
}