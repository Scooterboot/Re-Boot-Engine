switch scr_round(aimFrame)
{
    case -4:
    {
        scr_ArmPos((7+(dir == -1))*dir, 19);
        if(recoilCounter > 0)
        {
            armOffsetY -= 1;
        }
        break;
    }
    case -3:
    {
        scr_ArmPos((13+(dir == -1))*dir, 14);
        break;
    }
    case -2:
    {
        scr_ArmPos(18*dir,8);
        if(recoilCounter > 0 && stateFrame != "walk" && stateFrame != "run")
        {
            armOffsetX -= 1*dir;
            armOffsetY -= 1;
        }
        break;
    }
    case -1:
    {
        scr_ArmPos(17*dir, 5);
        break;
    }
    case 1:
    {
        scr_ArmPos(18*dir, -13);
        break;
    }
    case 2:
    {
        scr_ArmPos(17*dir, -20);
        if(recoilCounter > 0 && stateFrame != "walk" && stateFrame != "run")
        {
            armOffsetX -= 1*dir;
            armOffsetY += 1;
        }
        break;
    }
    case 3:
    {
        scr_ArmPos((11+(2*(dir == -1)))*dir,-(26+(dir == -1)));
        break;
    }
    case 4:
    {
        scr_ArmPos(2*dir, -28);
        if(recoilCounter > 0)
        {
            armOffsetY += 1;
        }
        break;
    }
    default:
    {
        scr_ArmPos(15*dir,1);
        if(recoilCounter > 0)
        {
            armOffsetX -= 1*dir;
        }
        break;
    }
}