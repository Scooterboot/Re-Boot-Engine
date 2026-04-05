/// @description Initialize

velX = 0;
velY = 0;
velInit = 3;

mouseGlow = 0;
mouseGlowSurf = surface_create(11,15);

hide = true;
image_alpha = 0;

idleTime = 0;
idleMax = 600;

function PosX()
{
	var screenScale = instance_exists(obj_Display) ? obj_Display.screenScale : 1;
	return (device_mouse_x_to_gui(0)/screenScale) - (global.screenX/screenScale);
}
function PosY()
{
	var screenScale = instance_exists(obj_Display) ? obj_Display.screenScale : 1;
	return (device_mouse_y_to_gui(0)/screenScale) - (global.screenY/screenScale);
}

function PosX_Room()
{
	var screenScale = instance_exists(obj_Display) ? obj_Display.screenScale : 1;
	return mouse_x - (global.screenX/screenScale);
}
function PosY_Room()
{
	var screenScale = instance_exists(obj_Display) ? obj_Display.screenScale : 1;
	return mouse_y - (global.screenY/screenScale);
}