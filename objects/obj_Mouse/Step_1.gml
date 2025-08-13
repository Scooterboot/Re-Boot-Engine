/// @description Set position

x = MousePos().X;
y = MousePos().Y;

posX = MousePos_Room().X;
posY = MousePos_Room().Y;

velX = x - xprevious;
velY = y - yprevious;

// Fixes an issue where the mouse becomes unhidden
// when the game first opens, despite the mouse not being moved.
if(velInit > 0)
{
	velX = 0;
	velY = 0;
	velInit--;
}

if(velX != 0 || velY != 0 || mouse_check_button(mb_any) || mouse_wheel_up() || mouse_wheel_down())
{
	hide = false;
	idleTime = 0;
}
/*if(keyboard_check(vk_anykey) || gamepad_button_check(global.gpSlot,gp_anybutton()) || gamepad_axis_value(global.gpSlot, gp_axislh) != 0 || gamepad_axis_value(global.gpSlot, gp_axislv) != 0)
{
	hide = true;
}*/

if(!hide)
{
	if(idleTime < idleMax)
	{
		idleTime++;
	}
	else
	{
		hide = true;
	}
}
else
{
	idleTime = 0;
}

if(room != rm_MainMenu) //if(is in ui state)
{
	hide = true;
}