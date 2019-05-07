/// @description scr_CorrectGamepadString(button)
/// @param button
switch(argument0)
{
    case gp_face1:
    {
        return "BUTTON A";
        break;
    }
    case gp_face2:
    {
        return "BUTTON B";
        break;
    }
    case gp_face3:
    {
        return "BUTTON X";
        break;
    }
    case gp_face4:
    {
        return "BUTTON Y";
        break;
    }
    case gp_shoulderl:
    {
        return "L SHOULDER";
        break;
    }
    case gp_shoulderlb:
    {
        return "L TRIGGER";
        break;
    }
    case gp_shoulderr:
    {
        return "R SHOULDER";
        break;
    }
    case gp_shoulderrb:
    {
        return "R TRIGGER";
        break;
    }
    case gp_select:
    {
        return "SELECT";
        break;
    }
    case gp_start:
    {
        return "START";
        break;
    }
    case gp_stickl:
    {
        return "L STICK BUTTON";
        break;
    }
    case gp_stickr:
    {
        return "R STICK BUTTON";
        break;
    }
    default:
    {
        return string(argument0);
        break;
    }
}
