/// @description Detect Controller
show_debug_message("Event = " + async_load[? "event_type"]);
show_debug_message("Pad = " + string(async_load[? "pad_index"]));

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

switch (async_load[? "event_type"])
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
}