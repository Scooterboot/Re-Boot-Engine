/// @description Detect Controller
//show_debug_message("Event = " + async_load[? "event_type"]);
//show_debug_message("Pad = " + string(async_load[? "pad_index"]));

/*switch(async_load[? "event_type"])
{
    case "gamepad discovered":
    {
        var pad = async_load[? "pad_index"];
        if(global.gpSlot == -1)
        {
            global.gpSlot = pad;
        }
        break;
    }
    case "gamepad lost":
    {
        //var pad = async_load[? "pad_index"];
        global.gpSlot = -1;
        break;
    }
}*/

/*switch (async_load[? "event_type"])
{
    case "gamepad discovered":
    {
        scr_LoadGamePadID();
        break;
    }
    case "gamepad lost":
    {
        scr_LoadGamePadID();
        break;
    }
}*/

/*switch (async_load[? "event_type"])
{
	case "gamepad discovered":
	{
		var _pad = async_load[? "pad_index"];
		gamepad_set_axis_deadzone(_pad, 0.2);
		array_push(global.gamepad, _pad);
		array_push(global.gpButtonCount, gamepad_button_count(_pad));
		break;
	}
	case "gamepad lost":
	{
		var _pad = async_load[? "pad_index"];
		var _index = array_get_index(global.gamepad, _pad);
		array_delete(global.gamepad, _index, 1);
		_index = array_get_index(global.gpButtonCount, gamepad_button_count(_pad));
		array_delete(global.gpButtonCount, _index, 1);
		break;
	}
}*/