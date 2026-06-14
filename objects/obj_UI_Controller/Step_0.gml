/// @description 

var _device = InputPlayerGetDevice();

if(room == rm_MainMenu || room == rm_GameOver || room == rm_Disclaimer || global.GamePaused())
{
	if (_device == INPUT_KBM)
	{
		if(instance_exists(obj_Mouse) && !obj_Mouse.hide)
		{
			usingMouse = true;
		}
		else if(InputPressedMany(-1) && !InputMouseCheck(mb_any) && !mouse_wheel_up() && !mouse_wheel_down())
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
		var _dX = global.control[INPUT_VERB.MenuRight] - global.control[INPUT_VERB.MenuLeft],
			_dY = global.control[INPUT_VERB.MenuDown] - global.control[INPUT_VERB.MenuUp];
	    BentoInputNavigation(_dX, _dY, global.control[INPUT_VERB.MenuAccept], 0);
	}
	
	BentoInputHotkey(BENTO_HOTKEY_CANCEL, (global.controlPressed[INPUT_VERB.MenuCancel] || InputMousePressed(mb_right)));
	BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_UP, global.control[INPUT_VERB.MenuScrollUp]);
	BentoInputHotkey(BENTO_HOTKEY_MOUSE_WHEEL_DOWN, global.control[INPUT_VERB.MenuScrollDown]);
	BentoInputConfigureRetrigger(30,5,10,3);
	
	BentoSystemStep(0, 0, global.resWidth, global.resHeight);
}

updateText = false;
if(_device != prevDevice)
{
	self.GetClusterIcons();
	self.GetButtonIcons();
	
	updateText = true;
	prevDevice = _device;
}
