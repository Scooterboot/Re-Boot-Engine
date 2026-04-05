/// @description Set position

x = scr_round(self.PosX());
y = scr_round(self.PosY());

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
if(InputPressedMany(-1))
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