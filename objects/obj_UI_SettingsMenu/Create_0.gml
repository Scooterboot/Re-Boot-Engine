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

inputBlockLayer = "input block (settings menu)";

#region Default Menu

defMenuText = [
"DISPLAY SETTINGS",
"AUDIO SETTINGS",
"GAMEPLAY SETTINGS",
"KEYBOARD BINDINGS",
"CONTROLLER BINDINGS",
"BACK"];

defaultMenuLayer = "default menu";
function CreateDefaultMenu()
{
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _mainElement = new BentoUI_Spacer(BentoLayerCreate(defaultMenuLayer));
	with(_mainElement)
	{
		BentoLayoutSetGutter(0, 3);
		BentoLayoutSetResize(BENTO_RESIZE_INFLATE, BENTO_RESIZE_INFLATE);
		BentoLayoutList(BENTO_AXIS_Y, 0, 0.5);
		BentoSetOffset(ww/2-76);
	}
	
	var btn = [],
		btnFunc = [],
		btnW = 152,
		btnH = 11;
	
	btnFunc[0] = function()
	{
		
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[1] = function()
	{
		
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[2] = function()
	{
		
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[3] = function()
	{
		creatorUI.state = UI_SMState.Keyboard;
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[4] = function()
	{
		
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[5] = function()
	{
		creatorUI.activeState = UI_ActiveState.Deactivating;
		
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	for(var i = 0; i < array_length(defMenuText); i++)
	{
		var _bw = btnW;
		if(i == 5)
		{
			_bw = 56;
		}
		
		btn[i] = new BentoUI_Button(btnFunc[i], _bw, btnH, defMenuText[i], this, _mainElement);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
		if(i < 5)
		{
			btn[i].textAlignX = fa_left;
		}
		else
		{
			BentoSetOffset(,16,btn[i]);
			btn[i].hotKey = btn[i].hotKey_cancel;
		}
		
		if(i == 0 || i == 5)
		{
			BentoSetNavigationWrap(false, true, btn[i]);
		}
		
		BentoAnimPlayBuildIn(7,2*i, 0,0,0,1, 0,animCur_UI_Basic,false,btn[i]);
	}
}
#endregion

#region Binding names

bindingText = [

"Menu - Up",
"Menu - Down",
"Menu - Left",
"Menu - Right",
"Scroll Up",
"Scroll Down",

"Start",
"Menu - Accept",
"Menu - Cancel",
"Menu - Secondary",
"Menu - Tertiary",
"Menu - R1",
"Menu - R2",
"Menu - L1",
"Menu - L2",

"Up",
"Down",
"Left",
"Right",

"Jump",
"Fire",
"Sprint",
"Dodge",
"Insta-Shield",
"Morph",
"Boost Ball",
"Spider Ball",

"Aim Angle Up",
"Aim Angle Down",
"Aim Lock",
"Reverse Aim",
"Moonwalk",

"Toggle Off-hand",

"Visor Toggle",
"Visor Cycle",

"Open Radial Menu",
"Radial Menu Up",
"Radial Menu Down",
"Radial Menu Left",
"Radial Menu Right",

"Activate Visor",
"Visor Up",
"Visor Down",
"Visor Left",
"Visor Right"

];

#endregion
#region KB Bindings Menu

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

kbBindMenuLayer = "kb binding menu";
function CreateKBBindMenu()
{
	var ww = global.resWidth,
		ww2 = global.ogResWidth,
		hh = global.resHeight,
		this = id;
	
	var _lW = ww2-16,
		_lH = hh-26;
	var _mainList = new BentoUI_ScrollList_Page(_lW, _lH, 2, this, BentoLayerCreate(kbBindMenuLayer));
	with(_mainList)
	{
		BentoSetOrigin(0.5, 0);
		BentoSetPosition(ww/2, 13);
	}
	
	var _space = new BentoUI_Spacer(_mainList);
	BentoLayoutSetSize(,8,_space);
	
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
	
	var pnlW = 302,
		pnlH = 11,
		btnW = pnlW/2,
		btnH = 11;
	for(var i = 0; i < INPUT_VERB._Length; i++)
	{
		var _pnl = new BentoUI_SettingsOptPanel(undefined, pnlH, bindingText[i], this, _mainList);
		BentoLayoutSetGutter(2, 0, _pnl);
		BentoLayoutList(BENTO_AXIS_X, 1, 0, _pnl);
		
		var _preBtn = new BentoUI_Button(, 79, 11, pressText, this, _pnl);
		_preBtn.sprtAlpha = 0.75;
		_preBtn.sprtSelectAlpha = 0.85;
		_preBtn.inputVerb = i;
		_preBtn.getText = method(_preBtn, function()
		{
			return self._GetText()[global.controlInput[inputVerb].pressType_KB];
		});
		
		var _b1Btn = new BentoUI_Button(, 31, 11, "", this, _pnl);
		_b1Btn.sprt = sprt_UI_Button2;
		_b1Btn.sprtAlpha = 0.75;
		_b1Btn.sprtSelectAlpha = 0.85;
		_b1Btn.inputVerb = i;
		_b1Btn.inputAlt = 0;
		_b1Btn.getText = method(_b1Btn, getBindText);
		_b1Btn.textScribbleType = UI_TextScribType.ScribDeluxe;
		_b1Btn.textShadow = false;
		
		var _comBtn = new BentoUI_Button(, 21, 11, comboText, this, _pnl);
		_comBtn.sprt = sprt_UI_Button2;
		_comBtn.sprtAlpha = 0.75;
		_comBtn.sprtSelectAlpha = 0.85;
		_comBtn.inputVerb = i;
		_comBtn.getText = method(_comBtn, function()
		{
			return self._GetText()[global.controlInput[inputVerb].comboType_KB];
		});
		
		var _b2Btn = new BentoUI_Button(, 31, 11, "", this, _pnl);
		_b2Btn.sprt = sprt_UI_Button2;
		_b2Btn.sprtAlpha = 0.75;
		_b2Btn.sprtSelectAlpha = 0.85;
		_b2Btn.inputVerb = i;
		_b2Btn.inputAlt = 1;
		_b2Btn.getText = method(_b2Btn, getBindText);
		_b2Btn.textScribbleType = UI_TextScribType.ScribDeluxe;
		_b2Btn.textShadow = false;
	}
	
	_space = new BentoUI_Spacer(_mainList);
	BentoLayoutSetSize(,8,_space);
	
	var _bbtn = new BentoUI_Spacer(_mainList);
	BentoLayoutSetSize(56, 11,_bbtn);
	
	var backFunc = function()
	{
		creatorUI.state = UI_SMState.Default;
				
		audio_play_sound(snd_MenuTick,0,false);
	}
	var backBtn = new BentoUI_Button(backFunc, 56, 11, "BACK", this, _bbtn);
	backBtn.sprtAlpha = 0.75;
	backBtn.sprtSelectAlpha = 0.85;
	backBtn.hotKey = backBtn.hotKey_cancel;
	
	_space = new BentoUI_Spacer(_mainList);
	BentoLayoutSetSize(,8,_space);
}
#endregion

headerTextRaw = [
"SETTINGS",
"DISPLAY SETTINGS",
"AUDIO SETTINGS",
"GAMEPLAY SETTINGS",
"KEYBOARD BINDINGS",
"CONTROLLER BINDINGS"];
headerText = [];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
footerText = [];
