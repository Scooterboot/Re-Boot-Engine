/// @description Initialize

enum ComboType
{
	Or,
	And,
	AndNot,
	Xor
}
enum PressType
{
	Tap,
	DoubleTap,
	Press,
	LongPress,
	Hold,
	LongHold,
	Release
}
#region ControlInput struct
function ControlInput(_verbIndex, _keyboardPressType, _keyboardComboType, _gamepadPressType, _gamepadComboType) constructor
{
	verbIndex = _verbIndex;
	defaultPressType_KB = _keyboardPressType;
	defaultComboType_KB = _keyboardComboType;
	defaultPressType_GP = _gamepadPressType;
	defaultComboType_GP = _gamepadComboType;
	
	pressType_KB = defaultPressType_KB;
	comboType_KB = defaultComboType_KB;
	pressType_GP = defaultPressType_GP;
	comboType_GP = defaultComboType_GP;
	
	pressType = pressType_KB;
	comboType = comboType_KB;
	
	inputCounter = 0;
	inputCounterMax = 15;
	
	function GetInput()
	{
		var _isGamepad = InputPlayerUsingGamepad();
		
		pressType = pressType_KB;
		comboType = comboType_KB;
		if(_isGamepad)
		{
			pressType = pressType_GP;
			comboType = comboType_GP;
		}
		
		var _input = false;
		if(comboType == ComboType.Or)
		{
			_input = InputCheck(verbIndex);
		}
		else
		{
			_input = InputCheck_Ext(verbIndex, 0);
			if(!is_undefined(InputBindingGet(_isGamepad, verbIndex, 1)))
			{
				if(comboType == ComboType.And)
				{
					_input &= InputCheck_Ext(verbIndex, 1);
				}
				if(comboType == ComboType.AndNot)
				{
					_input &= !InputCheck_Ext(verbIndex, 1);
				}
				if(comboType == ComboType.Xor)
				{
					_input ^= InputCheck_Ext(verbIndex, 1);
				}
			}
		}
		
		if(pressType == PressType.Tap)
		{
			return (_input && InputBufferPressed(verbIndex, inputCounterMax));
		}
		
		if(pressType == PressType.DoubleTap)
		{
			if(_input && InputPressed(verbIndex))
			{
				if(inputCounter <= 0)
				{
					inputCounter = inputCounterMax;
				}
				else
				{
					return true;
				}
			}
			inputCounter = max(inputCounter-1, 0);
		}
		else
		{
			inputCounter = 0;
		}
		
		if(pressType == PressType.Press || pressType == PressType.Hold)
		{
			return _input;
		}
		if(pressType == PressType.LongPress || pressType == PressType.LongHold)
		{
			return (_input && InputLong(verbIndex,,inputCounterMax));
		}
		
		if(pressType == PressType.Release)
		{
			return (_input && InputReleased(verbIndex));
		}
		
		return false;
	}
}
#endregion

for(var i = 0; i < INPUT_VERB._Length; i++)
{
	var _pressTypeKB = PressType.Press,
		_comboTypeKB = ComboType.Or,
		_pressTypeGP = PressType.Press,
		_comboTypeGP = ComboType.Or;
	
	if(i == INPUT_VERB.MenuScrollUp || i == INPUT_VERB.MenuScrollDown)
	{
		_comboTypeKB = ComboType.AndNot;
	}
	if(i == INPUT_VERB.MenuScrollLeft || i == INPUT_VERB.MenuScrollRight)
	{
		_comboTypeKB = ComboType.And;
	}
	
	if(i == INPUT_VERB.Sprint || INPUT_VERB.SpiderBall)
	{
		_pressTypeKB = PressType.Hold;
		_pressTypeGP = PressType.Hold;
	}
	if(i == INPUT_VERB.AimLock)
	{
		_comboTypeKB = ComboType.And;
		_comboTypeGP = ComboType.And;
	}
	
	global.controlInput[i] = new ControlInput(i, _pressTypeKB, _comboTypeKB, _pressTypeGP, _comboTypeGP);
	global.control[i] = false;
}

for(var i = 0; i < INPUT_CLUSTER._Length; i++)
{
	global.controlClustX[i] = 0;
	global.controlClustY[i] = 0;
	global.controlDirection[i] = 0;
	global.controlDistance[i] = 0;
}

ini_open("settings.ini");
	global.HUD = ini_read_real("Controls", "hud style", 0);
	global.aimStyle = ini_read_real("Controls", "aim style", 0);
	global.autoSprint = ini_read_real("Controls", "auto sprint", false);
	global.quickClimb = ini_read_real("Controls", "quick climb", true);

	global.gripStyle = ini_read_real("Controls", "grip control", 0);
	global.grappleStyle = ini_read_real("Controls", "grapple control", 0);
	global.spiderBallStyle = ini_read_real("Controls", "spiderball control", 0);
	global.dodgeStyle = ini_read_real("Controls", "dodge control", 0);
	
	global.grappleAimAssist = ini_read_real("Controls", "grapple aim assist", true);
ini_close();

// temp
InputPlayerSetMinThreshold(INPUT_THRESHOLD.BOTH, 0.35);
//InputPlayerSetMaxThreshold(INPUT_THRESHOLD.BOTH, 0.9);
