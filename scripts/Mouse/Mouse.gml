
function MousePos()
{
	var screenScale = 1;
	if(instance_exists(obj_Display))
	{
		screenScale = obj_Display.screenScale;
	}
	return new Vector2(
			(device_mouse_x_to_gui(0)/screenScale) - (global.screenX/screenScale), 
			(device_mouse_y_to_gui(0)/screenScale) - (global.screenY/screenScale));
}

function MousePos_Room()
{
	var screenScale = 1;
	if(instance_exists(obj_Display))
	{
		screenScale = obj_Display.screenScale;
	}
	return new Vector2(
			mouse_x - (global.screenX/screenScale), 
			mouse_y - (global.screenY/screenScale));
}