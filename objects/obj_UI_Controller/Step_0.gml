/// @description 

/* // Not using Bento yet, but will in the future
SetControlVars(cGroup);

var _device = InputPlayerGetDevice();
if (_device == INPUT_KBM)
{
	if(instance_exists(obj_Mouse) && !obj_Mouse.hide)
	{
		usingMouse = true;
	}
	else if(InputPressedMany(-1) && !InputMouseCheck(mb_any))
	{
		usingMouse = false;
	}
	
	if(usingMouse)
	{
		BentoSetMode(BENTO_MODE_MOUSE);
	}
	else
	{
		BentoSetMode(BENTO_MODE_KEYBOARD);
	}
}
else if (_device == INPUT_TOUCH)
{
    BentoSetMode(BENTO_MODE_TOUCH);
}
else if (InputDeviceIsGamepad(_device))
{
    BentoSetMode(BENTO_MODE_GAMEPAD);
}

if (BentoUsingPointer() && instance_exists(obj_Mouse))
{
	BentoInputPointer(obj_Mouse.PosX(), obj_Mouse.PosY(), InputMouseCheck());
}
else
{
	var _dX = cMenuRight - cMenuLeft,
		_dY = cMenuDown - cMenuUp;
    BentoInputNavigation(_dX, _dY, cMenuAccept, 0);
}

BentoInputHotkey(BENTO_HOTKEY_CANCEL, (cMenuCancel || InputMouseCheck(mb_right)));
BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_UP, cMenuScrollUp);
BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_DOWN, cMenuScrollDown);
BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_LEFT, cMenuScrollLeft);
BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_RIGHT, cMenuScrollRight);

BentoSystemStep(0, 0, global.resWidth, global.resHeight);
*/
var _device = InputPlayerGetDevice();

updateText = false;
if(_device != prevDevice)
{
	self.GetClusterIcons();
	self.GetButtonIcons();
	
	updateText = true;
	prevDevice = _device;
}

//SetReleaseVars(cGroup);
