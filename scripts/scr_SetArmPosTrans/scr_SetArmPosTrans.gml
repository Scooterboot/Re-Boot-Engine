switch scr_round(aimFrame)
{
    case -2:
    {
        scr_ArmPos(19*dir,8+(dir == -1));
        break;
    }
    case 2:
    {
        scr_ArmPos((20 - (dir == -1))*dir, -21);
        break;
    }
    default:
    {
        scr_SetArmPosJump();
        break;
    }
}