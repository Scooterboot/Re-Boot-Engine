/// @description Define & Set



/*if(gamepad_is_supported() && array_length(global.gamepad) > 0)
{
	for (var i = 0; i < array_length(global.gamepad); i++)
	{
		if(gamepad_is_connected(global.gamepad[i]) && gamepad_button_check(global.gamepad[i], gp_anybutton(i)))
		{
			global.gamepadIndex = i;
			global.gpSlot = global.gamepad[i];
			break;
		}
	}
}
else
{
	global.gamepadIndex = 0;
	global.gpSlot = -1;
}

if(keyboard_check(vk_anykey))
{
	usingGamePad = false;
}
if (global.gpSlot > -1 && gamepad_is_connected(global.gpSlot) && 
	(gamepad_button_check(global.gpSlot,gp_anybutton()) || 
	gamepad_axis_value(global.gpSlot, gp_axislh) != 0 || 
	gamepad_axis_value(global.gpSlot, gp_axislv) != 0 || 
	gamepad_axis_value(global.gpSlot, gp_axisrh) != 0 || 
	gamepad_axis_value(global.gpSlot, gp_axisrv) != 0))
{
	usingGamePad = true;
}

// temp code
/*if(gamepad_is_supported())
{
	for (var i = 0; i < gamepad_get_device_count(); i++)
	{
	    if(gamepad_is_connected(i) && gamepad_button_check(i, gp_anybutton(i)))
	    {
	        global.gpSlot = i;
	        global.gpButtonNum = gamepad_button_count(global.gpSlot);
	        break;
	    }
	}
}*/
// temp code

/*
///Define
kUp = keyboard_check(global.key[0]);
kDown = keyboard_check(global.key[1]);
kLeft = keyboard_check(global.key[2]);
kRight = keyboard_check(global.key[3]);
kJump = keyboard_check(global.key[4]);
kShoot = keyboard_check(global.key[5]);
kSprint = keyboard_check(global.key[6]);
kAngleUp = keyboard_check(global.key[7]);
kAngleDown = keyboard_check(global.key[8]);
kAimLock = keyboard_check(global.key[9]);
kQuickMorph = keyboard_check(global.key[10]);

kHSelect = keyboard_check(global.key[11]);
kHCancel = keyboard_check(global.key[12]);

kStart = keyboard_check(global.key_m[0]);

kMUp = keyboard_check(global.key[0]);
kMDown = keyboard_check(global.key[1]);
kMLeft = keyboard_check(global.key[2]);
kMRight = keyboard_check(global.key[3]);
kMSelect = keyboard_check(global.key_m[1]);
kMCancel = keyboard_check(global.key_m[2]);

if(gamepad_is_connected(global.gpSlot))
{
	gamepad_set_axis_deadzone(global.gpSlot, global.gp_deadZone);
	
    gRight = (gamepad_button_check(global.gpSlot, gp_padr) && global.gp_usePad) || (gamepad_axis_value(global.gpSlot, gp_axislh) > 0 && global.gp_useStick);
    gLeft = (gamepad_button_check(global.gpSlot, gp_padl) && global.gp_usePad) || (gamepad_axis_value(global.gpSlot, gp_axislh) < 0 && global.gp_useStick);
    gUp = (gamepad_button_check(global.gpSlot, gp_padu) && global.gp_usePad) || (gamepad_axis_value(global.gpSlot, gp_axislv) < 0 && global.gp_useStick);
    gDown = (gamepad_button_check(global.gpSlot, gp_padd) && global.gp_usePad) || (gamepad_axis_value(global.gpSlot, gp_axislv) > 0 && global.gp_useStick);
    gJump = gamepad_button_check(global.gpSlot, global.gp[0]);
    gShoot = gamepad_button_check(global.gpSlot, global.gp[1]);
    gSprint = gamepad_button_check(global.gpSlot, global.gp[2]);
    gAngleUp = gamepad_button_check(global.gpSlot, global.gp[3]);
    gAngleDown = gamepad_button_check(global.gpSlot, global.gp[4]);
    gAimLock = gamepad_button_check(global.gpSlot, global.gp[5]);
    gQuickMorph = gamepad_button_check(global.gpSlot, global.gp[6]);
    
    gHSelect = gamepad_button_check(global.gpSlot, global.gp[7]);
    gHCancel = gamepad_button_check(global.gpSlot, global.gp[8]);
    
    gStart = gamepad_button_check(global.gpSlot, global.gp_m[0]);
    
	gMRight = gRight;
	gMLeft = gLeft;
	gMUp = gUp;
	gMDown = gDown;
    gMSelect = gamepad_button_check(global.gpSlot, global.gp_m[1]);
    gMCancel = gamepad_button_check(global.gpSlot, global.gp_m[2]);
}

///Set

right = kRight;
left = kLeft;
up = kUp;
down = kDown;
jump = kJump;
shoot = kShoot;
sprint = kSprint;
angleUp = kAngleUp;
angleDown = kAngleDown;
aimLock = kAimLock;
quickMorph = kQuickMorph;

hSelect = kHSelect;
hCancel = kHCancel;

mRight = kMRight;
mLeft = kMLeft;
mUp = kMUp;
mDown = kMDown;
mSelect = kMSelect;
mCancel = kMCancel;

start = kStart;

if(gamepad_is_connected(global.gpSlot))
{
    right |= gRight;
    left |= gLeft;
    up |= gUp;
    down |= gDown;
    jump |= gJump;
    shoot |= gShoot;
    sprint |= gSprint;
    angleUp |= gAngleUp;
    angleDown |= gAngleDown;
    aimLock |= gAimLock;
	quickMorph |= gQuickMorph;
    
    hSelect |= gHSelect;
    hCancel |= gHCancel;
    
    mRight |= gMRight;
    mLeft |= gMLeft;
    mUp |= gMUp;
    mDown |= gMDown;
    mSelect |= gMSelect;
    mCancel |= gMCancel;
    
    start |= gStart;
}

if(keyboard_check(vk_anykey))
{
	usingGamePad = false;
}
if(gamepad_button_check(global.gpSlot,gp_anybutton()) || gamepad_axis_value(global.gpSlot, gp_axislh) != 0 || gamepad_axis_value(global.gpSlot, gp_axislv) != 0)
{
	usingGamePad = true;
}

leftClick = (mouse_button == mb_left);
rightClick = (mouse_button == mb_right);

cursorActive = (cursorActiveTimer > 0);
if(mouse_button == mb_any || mouse_x != mousePrevX || mouse_y != mousePrevY)
{
	cursorActiveTimer = 300;
}

cursorActiveTimer = max(cursorActiveTimer - 1, 0);

mousePrevX = mouse_x;
mousePrevY = mouse_y;
*/