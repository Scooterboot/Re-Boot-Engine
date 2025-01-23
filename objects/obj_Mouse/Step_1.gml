/// @description Set position

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	screenScale = obj_Display.screenScale;

x = (window_mouse_get_x()/screenScale) - (global.screenX/screenScale);
y = (window_mouse_get_y()/screenScale) - (global.screenY/screenScale);

posX = mouse_x - (global.screenX/screenScale);
posY = mouse_y - (global.screenY/screenScale);

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
if(keyboard_check(vk_anykey) || gamepad_button_check(global.gpSlot,gp_anybutton()) || gamepad_axis_value(global.gpSlot, gp_axislh) != 0 || gamepad_axis_value(global.gpSlot, gp_axislv) != 0)
{
	hide = true;
}

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