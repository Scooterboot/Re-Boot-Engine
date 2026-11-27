// Inherit the parent event
event_inherited();

var ww = global.resWidth,
	ww2 = global.ogResWidth,
	hh = global.resHeight,
	this = id;

var _lW = ww2-16,
	_lH = hh-26;
var _mainList = new BentoUI_ScrollList_Page(_lW, _lH, 2, this, mainLayer);
with(_mainList)
{
	BentoSetOrigin(0.5, 0);
	BentoSetPosition(ww/2, 13);
}

var _space = new BentoUI_Spacer(_mainList);
BentoLayoutSetSize(,8,_space);

//

_space = new BentoUI_Spacer(_mainList);
BentoLayoutSetSize(,8,_space);

var _bbtn = new BentoUI_Spacer(_mainList);
BentoLayoutSetSize(56, 11,_bbtn);

var backFunc = function()
{
	creatorUI.activeState = UI_ActiveState.Inactive;
				
	audio_play_sound(snd_MenuTick,0,false);
}
var backBtn = new BentoUI_Button(backFunc, 56, 11, "BACK", this, _bbtn);
backBtn.sprtAlpha = 0.75;
backBtn.sprtSelectAlpha = 0.85;
backBtn.hotKey = backBtn.hotKey_cancel;

_space = new BentoUI_Spacer(_mainList);
BentoLayoutSetSize(,8,_space);

headerTextRaw = ["AUDIO SETTINGS"];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
