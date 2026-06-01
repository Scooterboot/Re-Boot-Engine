event_inherited();

enum UI_SMState
{
	Default,
	Display,
	Audio,
	Gameplay,
	Keyboard,
	Controller
}
state = UI_SMState.Default;

#region Default Page

defMenuText = [
"DISPLAY SETTINGS",
"AUDIO SETTINGS",
"GAMEPLAY SETTINGS",
"KEYBOARD BINDINGS",
"CONTROLLER BINDINGS",
"BACK"];

defaultPage = noone;
function CreateDefaultPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_GUI);
	
	defaultPage = self.CreatePage();
	var _panelW = global.ogResWidth,
		_panelH = hh-26,
		_panel = defaultPage.CreateUIPanel(, (ww-global.ogResWidth)/2, 13, _panelW,_panelH);
	
	var btn = [],
		btnW = 152,//104,
		btnH = 11;
	for(var i = 0; i < array_length(defMenuText); i++)
	{
		var str = defMenuText[i];
		var btnX = _panelW/2 - btnW/2,
			btnY = _panelH/2 - 35 + 14*i,
			strAlignX = fa_left;
		if(i == 5) // back button
		{
			btnW = 56;
			btnY += 28;
			strAlignX = fa_center;
		}
		
		btn[i] = _panel.CreateUIButton(, btnX, btnY, btnW, btnH, str);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
		btn[i].textAlignX = strAlignX;
	}
	
	btn[0].SetNavElements(btn[5],btn[1]);
	btn[0].OnClick = function()
	{
		state = UI_SMState.Display;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btn[1].SetNavElements(btn[0],btn[2]);
	btn[1].OnClick = function()
	{
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btn[2].SetNavElements(btn[1],btn[3]);
	btn[2].OnClick = function()
	{
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btn[3].SetNavElements(btn[2],btn[4]);
	btn[3].OnClick = function()
	{
		state = UI_SMState.Keyboard;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btn[4].SetNavElements(btn[3],btn[5]);
	btn[4].OnClick = function()
	{
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	btn[5].SetNavElements(btn[4],btn[0]);
	btn[5].OnClick = function()
	{
		activeState = UI_ActiveState.Deactivating;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btn[5].HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
}

#endregion
#region Display Page

displayText = [
"WINDOW MODE",
"DISPLAY SCALE",
"WIDESCREEN",
"V-SYNC",
"UPSCALING MODE",
"HUD DISPLAY",
"HUD MINIMAP",
"WATER DISTORTION",
"BACK"];

displayCycleText = [
["WINDOWED", "FULLSCREEN"],
["STRETCH", "x"],
["DISABLED", "ENABLED"],
["DISABLED", "ENABLED"],
["DISABLED"],
["DISABLED", "ENABLED"],
["DISABLED", "ENABLED"],
["DISABLED", "ENABLED"]];

displayPage = noone;
function CreateDisplayPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_GUI);
	
	displayPage = self.CreatePage();
	var _panelW = global.ogResWidth,
		_panelH = hh-26,
		_displayPanel = displayPage.CreateUIPanel(, (ww-global.ogResWidth)/2, 13, _panelW, _panelH,,,-1);
	
	var pnl = [],
		pnlX = 9,
		pnlY = 3,
		pnlW = 302,
		pnlH = 11,
		btn = [],
		btnX = pnlW/2,
		btnW = pnlW/2,
		btnH = 11;
	/*for(var i = 0; i < INPUT_VERB._Length; i++)
	{
		var str = "test_"+string(i);
		pnl[i] = _displayPanel.CreateUIPanel(, pnlX,pnlY,pnlW,pnlH,[str]);
		pnl[i].PreDraw = DrawSettingsOptPanel;
		pnlY += 13;
		
		var str2 = obj_UI_Controller.buttonIconKey[i]+"_0}";//"test2_"+string(i);
		btn[i] = pnl[i].CreateUIButton(, btnX,0,btnW,btnH,[str2]);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
	}*/
	
	var backBtn = _displayPanel.CreateUIButton(, pnlX,pnlY+13,56,btnH,["BACK"]);
	backBtn.OnClick = function()
	{
		state = UI_SMState.Default;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	backBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
}

#endregion

#region Binding names

bindingText = [

"MenuUp",
"MenuDown",
"MenuLeft",
"MenuRight",
"MenuScrollUp",
"MenuScrollDown",
"MenuScrollLeft",
"MenuScrollRight",

"Start",
"MenuAccept",
"MenuCancel",
"MenuSecondary",
"MenuTertiary",
"MenuR1",
"MenuR2",
"MenuL1",
"MenuL2",

"PlayerUp",
"PlayerDown",
"PlayerLeft",
"PlayerRight",

"Jump",
"Fire",
"Sprint",
"Dodge",
"InstaShield",
"Morph",
"BoostBall",
"SpiderBall",

"AimUp",
"AimDown",
"AimLock",
"ReverseAim",
"Moonwalk",

"EquipToggle",

"VisorToggle",
"VisorCycle",

"RadialUIOpen",
"RadialUIUp",
"RadialUIDown",
"RadialUILeft",
"RadialUIRight",

"VisorUse",
"VisorUp",
"VisorDown",
"VisorLeft",
"VisorRight"

];

#endregion

comboText = [
"OR",
"&",
"& !",
"XOR"
];

pressText = [
"Tap",
"Double Tap",
"Press",
"Long Press",
"Hold",
"Long Hold",
"Release"
];

#region Keyboard bindings page



kbBindPage = noone;
function CreateKBBindPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_GUI);
	
	kbBindPage = self.CreatePage();
	var _mPanelW = global.ogResWidth,
		_mPanelH = hh-26,
		_mPanel = kbBindPage.CreateUIPanel(, (ww-global.ogResWidth)/2, 13, _mPanelW, _mPanelH,,,-1);
	
	var pnl = [],
		pnlW = 302,
		pnlH = 11,
		pnlX = (_mPanelW/2) - (pnlW/2),
		pnlY = 4,
		btnX = 139,//pnlW/2,
		btnW = pnlW/2,
		btnH = 11;
	for(var i = 0; i < INPUT_VERB._Length; i++)
	{
		//var str = "test_"+string(i);
		var str = bindingText[i];
		pnl[i] = _mPanel.CreateUIPanel(, pnlX,pnlY,pnlW,pnlH,[str]);
		pnl[i].PreDraw = method(pnl[i], DrawSettingsOptPanel);
		pnl[i].canNavigate = true;
		pnl[i].canMouseSelect = true;
		pnlY += 13;
		
		var preBtn = pnl[i].CreateUIButton(, btnX,0, 79, btnH, pressText);
		preBtn.sprtAlpha = 0.75;
		preBtn.sprtSelectAlpha = 0.85;
		preBtn.inputVerb = i;
		preBtn.GetText = method(preBtn, function()
		{
			return self._GetText()[global.controlInput[inputVerb].pressType_KB];
		});
		
		var getBindText = function()
		{
			var _binding = InputBindingGet(false, inputVerb, inputAlt),
				_icon = InputIconGetDirect(_binding, false, INPUT_GAMEPAD_TYPE_NO_GAMEPAD),
				_str = UI_GetInputIconString(_icon);
			if(is_undefined(_str))
			{
				return "";
			}
			return _str;
		}
		
		var b1Btn = pnl[i].CreateUIButton(, btnX+80,0, 31,btnH);
		b1Btn.textFont = fnt_GUI_Small;
		b1Btn.useScribDeluxe = true;
		b1Btn.sprt = sprt_UI_Button2;
		b1Btn.sprtAlpha = 0.75;
		b1Btn.sprtSelectAlpha = 0.85;
		b1Btn.inputVerb = i;
		b1Btn.inputAlt = 0;
		b1Btn.GetText = method(b1Btn, getBindText);
		
		var comBtn = pnl[i].CreateUIButton(, btnX+80+32,0, 21,btnH, comboText);
		comBtn.sprt = sprt_UI_Button2;
		comBtn.sprtAlpha = 0.75;
		comBtn.sprtSelectAlpha = 0.85;
		comBtn.inputVerb = i;
		comBtn.GetText = method(comBtn, function()
		{
			return self._GetText()[global.controlInput[inputVerb].comboType_KB];
		});
		
		var b2Btn = pnl[i].CreateUIButton(, btnX+80+32+22,0, 31,btnH);
		b2Btn.textFont = fnt_GUI_Small;
		b2Btn.useScribDeluxe = true;
		b2Btn.sprt = sprt_UI_Button2;
		b2Btn.sprtAlpha = 0.75;
		b2Btn.sprtSelectAlpha = 0.85;
		b2Btn.inputVerb = i;
		b2Btn.inputAlt = 1;
		b2Btn.GetText = method(b2Btn, getBindText);
	}
	
	var backBtn = _mPanel.CreateUIButton(, pnlX,pnlY+13,56,btnH,["BACK"]);
	backBtn.OnClick = function()
	{
		state = UI_SMState.Default;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	backBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
}

#endregion

#region DrawSettingsOptPanel
function DrawSettingsOptPanel()
{
	var _x = posX,
		_y = posY,
		_alph = alpha,
		_alph2 = _alph * 0.75,
		_ind = 1;
	if(self.IsSelected())
	{
		_alph2 = _alph * 0.85;
		_ind = 0;
	}
	
	draw_sprite_stretched_ext(sprt_UI_OptPanel, _ind, _x, _y, width, height, c_white, _alph2);
	
	textAlignX = fa_left;
	self.DrawText(textColor);
	
	return true;
}
#endregion

updateText = true;

headerTextRaw = [
"SETTINGS",
"DISPLAY",
"AUDIO",
"GAMEPLAY",
"KEYBOARD",
"CONTROLLER"];
headerText = [];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
footerText = [];

surf = noone;

/*
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
		headerBtn[i].buttonScrib.starting_format(font_get_name(fnt_Menu),c_white);
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
	
	var _text = self.GetText();
	if(buttonScrib.get_text() != _text)
	{
		buttonScrib.overwrite(_text);
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
	//
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
*/
