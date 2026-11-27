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
			bentoInputMode = BENTO_MODE_MOUSE;
		}
		else
		{
			bentoInputMode = BENTO_MODE_KEYBOARD;
		}
	}
	else if (_device == INPUT_TOUCH)
	{
		bentoInputMode = BENTO_MODE_TOUCH;
	}
	else if (InputDeviceIsGamepad(_device))
	{
		bentoInputMode = BENTO_MODE_GAMEPAD;
	}
	BentoInputConfigureRetrigger(30,5,10,3);
}

updateText = false;
if(_device != prevDevice)
{
	self.GetClusterIcons();
	self.GetButtonIcons();
	
	updateText = true;
	prevDevice = _device;
}
