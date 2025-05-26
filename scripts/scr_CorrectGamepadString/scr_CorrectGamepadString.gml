/// @description scr_CorrectGamepadString(button)
/// @param button
function scr_CorrectGamepadString(argument0) {
	switch(argument0)
	{
	    case gp_face1:
	    {
	        return "BUTTON A";
	    }
	    case gp_face2:
	    {
	        return "BUTTON B";
	    }
	    case gp_face3:
	    {
	        return "BUTTON X";
	    }
	    case gp_face4:
	    {
	        return "BUTTON Y";
	    }
	    case gp_shoulderl:
	    {
	        return "L SHOULDER";
	    }
	    case gp_shoulderlb:
	    {
	        return "L TRIGGER";
	    }
	    case gp_shoulderr:
	    {
	        return "R SHOULDER";
	    }
	    case gp_shoulderrb:
	    {
	        return "R TRIGGER";
	    }
	    case gp_select:
	    {
	        return "SELECT";
	    }
	    case gp_start:
	    {
	        return "START";
	    }
	    case gp_stickl:
	    {
	        return "L STICK BUTTON";
	    }
	    case gp_stickr:
	    {
	        return "R STICK BUTTON";
	    }
	    default:
	    {
	        return string(argument0);
	    }
	}



}
