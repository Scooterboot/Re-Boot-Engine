/// @description scr_CorrectKeyboardString(key)
/// @param key
function scr_CorrectKeyboardString(argument0) {
	switch(argument0)
	{
	    case vk_left:
	    {
	        return "LEFT";
	        break;
	    }
	    case vk_right:
	    {
	        return "RIGHT";
	        break;
	    }
	    case vk_up:
	    {
	        return "UP";
	        break;
	    }
	    case vk_down:
	    {
	        return "DOWN";
	        break;
	    }
	    case vk_enter:
	    {
	        return "ENTER";
	        break;
	    }
	    case vk_space:
	    {
	        return "SPACE";
	        break;
	    }
	    case vk_shift:
	    {
	        return "SHIFT";
	        break;
	    }
	    case vk_control:
	    {
	        return "CTRL";
	        break;
	    }
	    case vk_alt:
	    {
	        return "ALT";
	        break;
	    }
	    case vk_backspace:
	    {
	        return "BACKSPACE";
	        break;
	    }
	    case vk_tab:
	    {
	        return "TAB";
	        break;
	    }
	    case vk_home:
	    {
	        return "HOME";
	        break;
	    }
	    case vk_end:
	    {
	        return "END";
	        break;
	    }
	    case vk_delete:
	    {
	        return "DELETE";
	        break;
	    }
	    case vk_insert:
	    {
	        return "INSERT";
	        break;
	    }
	    case vk_pageup:
	    {
	        return "PAGE UP";
	        break;
	    }
	    case vk_pagedown:
	    {
	        return "PAGE DOWN";
	        break;
	    }
	    case vk_pause:
	    {
	        return "PAUSE";
	        break;
	    }
	    case vk_printscreen:
	    {
	        return "PRINT";
	        break;
	    }
	    case vk_multiply:
	    {
	        return "*";
	        break;
	    }
	    case vk_divide:
	    {
	        return "/";
	        break;
	    }
	    case vk_add:
	    {
	        return "+";
	        break;
	    }
	    case vk_subtract:
	    {
	        return "-";
	        break;
	    }
	    case vk_decimal:
	    {
	        return ".";
	        break;
	    }
	    default:
	    {
	        return string(chr(argument0));
	        break;
	    }
	}



}
