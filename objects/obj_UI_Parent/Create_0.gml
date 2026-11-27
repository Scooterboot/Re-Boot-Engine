/// @description 

enum UI_ActiveState
{
	Inactive,
	Deactivating,
	Active,
	Activating
}
activeState = UI_ActiveState.Inactive;

screenFade = 0;
screenFadeRate = 0.075;

cleanUp = true;

function UpdateBentoEnviro(_environment)
{
	BentoSetMode(obj_UI_Controller.bentoInputMode, _environment);
	
	if (BentoUsingPointer(_environment) && instance_exists(obj_Mouse))
	{
		BentoInputPointer(obj_Mouse.PosX(), obj_Mouse.PosY(), InputMouseCheck(), _environment);
	}
	else
	{
		var _dX = global.control[INPUT_VERB.MenuRight] - global.control[INPUT_VERB.MenuLeft],
			_dY = global.control[INPUT_VERB.MenuDown] - global.control[INPUT_VERB.MenuUp];
	    BentoInputNavigation(_dX, _dY, global.controlPressed[INPUT_VERB.MenuAccept], 0, _environment);
	}
	
	BentoInputHotkey(BENTO_HOTKEY_CANCEL, (global.controlPressed[INPUT_VERB.MenuCancel] || InputMousePressed(mb_right)), _environment);
	BentoInputHotkey(BENTO_HOTKEY_SCROLL_UP, global.control[INPUT_VERB.MenuScrollUp], _environment);
	BentoInputHotkey(BENTO_HOTKEY_SCROLL_DOWN, global.control[INPUT_VERB.MenuScrollDown], _environment);
	
	BentoEnvironmentUpdate(_environment, 0, 0, global.resWidth, global.resHeight);
}

updateText = true;

headerTextRaw = [""];
headerText = [""];

footerTextRaw = [""];
footerText = [""];

function UpdateText()
{
	if(updateText || obj_UI_Controller.updateText)
	{
		for(var i = 0; i < array_length(headerTextRaw); i++)
		{
			headerText[i] = UI_InsertIconsIntoString(headerTextRaw[i]);
		}
		for(var i = 0; i < array_length(footerTextRaw); i++)
		{
			footerText[i] = UI_InsertIconsIntoString(footerTextRaw[i]);
		}
		updateText = false;
	}
}
