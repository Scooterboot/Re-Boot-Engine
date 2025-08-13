/// @description scr_LoadGamePadID()
/*function scr_LoadGamePadID()
{
	global.gpSlot = -1;
	global.gpButtonNum = -1;

	if(gamepad_is_supported())
	{
		for (var i = 0; i < gamepad_get_device_count(); i++)
		{
			if(gamepad_is_connected(i))
			{
				global.gpSlot = i;
				global.gpButtonNum = gamepad_button_count(global.gpSlot);
				break;
			}
		}
	}
}
*/