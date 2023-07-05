/// @description scr_CorrectKeyboardString(key)
/// @param key
function scr_CorrectKeyboardString(argument0) {
	switch(argument0)
	{
	    case vk_left:
	    {
	        return "LEFT";
	    }
	    case vk_right:
	    {
	        return "RIGHT";
	    }
	    case vk_up:
	    {
	        return "UP";
	    }
	    case vk_down:
	    {
	        return "DOWN";
	    }
	    case vk_enter:
	    {
	        return "ENTER";
	    }
	    case vk_space:
	    {
	        return "SPACE";
	    }
	    case vk_shift:
	    {
	        return "SHIFT";
	    }
	    case vk_control:
	    {
	        return "CTRL";
	    }
	    case vk_alt:
	    {
	        return "ALT";
	    }
	    case vk_backspace:
	    {
	        return "BACKSPACE";
	    }
	    case vk_tab:
	    {
	        return "TAB";
	    }
	    case vk_home:
	    {
	        return "HOME";
	    }
	    case vk_end:
	    {
	        return "END";
	    }
	    case vk_delete:
	    {
	        return "DELETE";
	    }
	    case vk_insert:
	    {
	        return "INSERT";
	    }
	    case vk_pageup:
	    {
	        return "PAGE UP";
	    }
	    case vk_pagedown:
	    {
	        return "PAGE DOWN";
	    }
	    case vk_pause:
	    {
	        return "PAUSE";
	    }
	    case vk_printscreen:
	    {
	        return "PRINT";
	    }
	    case vk_multiply:
	    {
	        return "*";
	    }
	    case vk_divide:
	    {
	        return "/";
	    }
	    case vk_add:
	    {
	        return "+";
	    }
	    case vk_subtract:
	    {
	        return "-";
	    }
	    case vk_decimal:
	    {
	        return ".";
	    }
	    default:
	    {
	        return string(chr(argument0));
	    }
	}



}
