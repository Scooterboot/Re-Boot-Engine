event_inherited();

enum UI_SMState // Settings Menu state/page
{
	Display,
	Audio,
	Gameplay,
	Controls,
	
	_Length
}
state = UI_SMState.Display;

canTabSwitch = false;

#region Header Page

headerBtnText[UI_SMState.Display] = "DISPLAY";
headerBtnText[UI_SMState.Audio] = "AUDIO";
headerBtnText[UI_SMState.Gameplay] = "GAMEPLAY";
headerBtnText[UI_SMState.Controls] = "CONTROLS";

headerPage = noone;
function CreateHeaderPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_Menu);
	
	headerPage = self.CreatePage(,1);
	headerPage.DrawPage = DrawHeaderPage;
	
	var tabWidths = [],
		tabWTotal = 0;
	for(var i = 0; i < UI_SMState._Length; i++)
	{
		tabWidths[i] = string_width_scribble(headerBtnText[i])+6;
		tabWTotal += tabWidths[i];
	}
	
	var tabX = 0;
	var headerBtn = [];
	for(var i = 0; i < UI_SMState._Length; i++)
	{
		headerBtn[i] = headerPage.CreateUIButton(, (ww/2)-(tabWTotal/2)+tabX,0, tabWidths[i],12, headerBtnText[i]);
		headerBtn[i].mouseOnly = true;
		headerBtn[i].stateDest = i;
		headerBtn[i].OnClick = function()
		{
			state = other.stateDest;
			audio_play_sound(snd_MenuTick,0,false);
		}
		
		headerBtn[i].sprite_index = sprt_UI_TabButton;
		headerBtn[i].buttonScrib.starting_format("fnt_Menu",c_white);
		headerBtn[i].PreDraw = DrawTabButton;
		tabX += tabWidths[i];
	}
}

#endregion

#region DrawHeaderPage
function DrawHeaderPage()
{
	var ind = creatorUI.state;
	
	for(var i = 0; i < ind; i++)
	{
		var ele = elements[| i];
		ele.DrawElement();
	}
	for(var i = ds_list_size(elements)-1; i > ind; i--)
	{
		var ele = elements[| i];
		ele.DrawElement();
	}
	var ele = elements[| ind];
	ele.DrawElement();
	
	var tabWTotal = 0;
	for(var i = 0; i < ds_list_size(elements); i++)
	{
		tabWTotal += elements[| i].width;
	}
	
	var ww = global.resWidth;
	var lpos = ww/2 - tabWTotal/2 - 6,
		rpos = ww/2 + tabWTotal/2 + 6;
	
	var _icon = InputIconGet(INPUT_VERB.MenuL1);
	if(is_string(_icon))
	{
		draw_set_font(fnt_GUI);
		draw_set_align(fa_right,fa_top);
		draw_set_colour(c_white);
		draw_text_scribble(scr_round(lpos)-1,2,_icon);
		draw_sprite_ext(sprt_UI_Arrow, 0, scr_round(lpos-string_width_scribble(_icon)-2), 1, -1,1,0,c_white,1);
	}
	else if(asset_get_type(_icon) == asset_sprite || is_struct(_icon))
	{
		var _sprt = _icon,
			_img = 0;
		if(is_struct(_icon))
		{
			_sprt = _icon.spriteIndex;
			if(!is_undefined(_icon.imageIndex))
			{
				_img = _icon.imageIndex;
			}
		}
		var _so = sprite_get_xoffset(_sprt),
			_sw = sprite_get_width(_sprt);
		draw_sprite_ext(_sprt, _img, scr_round(lpos-(_sw-_so))-1, 4, 1,1,0,c_white,1);
		draw_sprite_ext(sprt_UI_Arrow, 0, scr_round(lpos-_sw-3), 1, -1,1,0,c_white,1);
	}
	
	_icon = InputIconGet(INPUT_VERB.MenuR1);
	if(is_string(_icon))
	{
		draw_set_font(fnt_GUI);
		draw_set_align(fa_left,fa_top);
		draw_set_colour(c_white);
		draw_text_scribble(scr_round(rpos)-1,2,_icon);
		draw_sprite_ext(sprt_UI_Arrow, 0, scr_round(rpos+string_width_scribble(_icon)), 1, 1,1,0,c_white,1);
	}
	else if(asset_get_type(_icon) == asset_sprite || is_struct(_icon))
	{
		var _sprt = _icon,
			_img = 0;
		if(is_struct(_icon))
		{
			_sprt = _icon.spriteIndex;
			if(!is_undefined(_icon.imageIndex))
			{
				_img = _icon.imageIndex;
			}
		}
		var _so = sprite_get_xoffset(_sprt),
			_sw = sprite_get_width(_sprt);
		draw_sprite_ext(_sprt, _img, scr_round(rpos+_so)-1, 4, 1,1,0,c_white,1);
		draw_sprite_ext(sprt_UI_Arrow, 0, scr_round(rpos+_sw+1), 1, 1,1,0,c_white,1);
	}
}
#endregion
#region DrawTabButton
function DrawTabButton()
{
	var _x = self.GetX(),
		_y = self.GetY();
	
	if(sprite_exists(sprite_index))
	{
		var _ind = sprtInd;
		if(creatorUI.state == stateDest)
		{
			_ind = sprtSelectInd;
		}
		
		var _ww = max(width+6, sprite_get_width(sprite_index)),
			_hh = max(height, sprite_get_height(sprite_index)),
			_xx = scr_round(_x+width/2-_ww/2),
			_yy = scr_round(_y+height/2-_hh/2);
		draw_sprite_stretched_ext(sprite_index,_ind, _xx,_yy, _ww,_hh, c_white,alpha);
	}
	
	var _text = text,
		_str = obj_UI_Icons.InsertIconsIntoString(_text);
	if(buttonScrib.get_text() != _str)
	{
		buttonScrib.overwrite(_str);
	}
	var col = c_grey;
	if(creatorUI.state == stateDest || instance_exists(self.GetMouse()))
	{
		col = c_white;
	}
	
	var xx = _x+scr_round(width/2), yy = _y+scr_round(height/2);
	buttonScrib.blend(col,1);
	buttonScrib.draw(xx,yy);
}
#endregion

genericCycleBtnText = ["DISABLED", "ENABLED"];

enum UI_SM_DMState // Display Menu state
{
	None
}
displayState = UI_SM_DMState.None;

#region Display page

displayOptHeader[0] = "GAME WINDOW";
displayOptText[0] = "WINDOW MODE";
displayCycleText[0] = ["WINDOWED", "BORDERLESS", "FULLSCREEN"];
displayOptText[1] = "DISPLAY SCALE";
displayCycleText[1] = ["x", "STRETCH"];
displayOptText[2] = "WIDESCREEN";

displayOptHeader[1] = "VIDEO";
displayOptText[3] = "V-SYNC";
displayOptText[4] = "WATER DISTORTION";

displayOptHeader[2] = "FILTERING";
displayOptText[5] = "CRT MODE";

displayOptHeader[3] = "HEADS UP DISPLAY";
displayOptText[6] = "HUD DISPLAY";
displayOptText[7] = "HUD MINIMAP";

displayOptText[8] = "BACK";

displayPage = noone;
function CreateDisplayPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	displayPage = self.CreatePage();
	
	var pnlX = (ww-global.ogResWidth)/2,
		pnlY = 13,
		pnlW = global.ogResWidth,
		pnlH = hh-pnlY*2;
	var mPnl = displayPage.CreateUIPanel(, pnlX,pnlY, pnlW,pnlH);
	
	var oTxt = [],
		oPnl = [],
		oBtn = [];
	
	/*
	var btnW = 296,
		btnH = 11;
	var fullScrBtn = mpnl.CreateUICycleButton(, (pnlW-btnW)/2,32, btnW,btnH, displayCycleText[0]);
	fullScrBtn.testVar = 0;
	fullScrBtn.GetCycleValue = function() { return other.testVar; }
	fullScrBtn.OnCycle = function(_dir)
	{with(other){
		testVar = scr_wrap(testVar+_dir,0,3);
		audio_play_sound(snd_MenuTick,0,false);
	}}
	fullScrBtn.GetText = function()
	{with(other){
		if(cycleMode)
		{
			return creatorUI.displayOptText[0]+" < "+cycleText[self.GetCycleValue()]+" >";
		}
		return creatorUI.displayOptText[0]+" "+cycleText[self.GetCycleValue()];
	}}
	*/
}

#endregion

enum UI_SM_AMState // Audio Menu state
{
	None
}
audioState = UI_SM_AMState.None;

enum UI_SM_GMState // Gameplay Menu state
{
	None
}
gameplayState = UI_SM_GMState.None;

enum UI_SM_CMState // Control Menu state
{
	None,
	Keyboard,
	Gamepad
}
controlState = UI_SM_CMState.None;

enum UI_SM_CMSubState // Control Menu sub state
{
	None
}
controlSubState = UI_SM_CMSubState.None;



surf = noone;

