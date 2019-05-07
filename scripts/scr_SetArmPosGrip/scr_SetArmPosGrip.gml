switch scr_round(gripAimFrame)
{
    case 1:
    {
        scr_ArmPos(-(18 + 2*(gripFrame >= 2) + gripFrame)*dir, 13 + (gripFrame >= 3));
        if(dir == -1)
        {
            scr_ArmPos(-(18 + clamp(gripFrame-1,0,1))*dir, 13 + clamp(gripFrame-1,0,2));
        }
        break;
    }
    case 2:
    {
        scr_ArmPos(-(23 + (gripFrame >= 1) + gripFrame)*dir, 9);
        if(dir == -1)
        {
            scr_ArmPos(-(23 + clamp(gripFrame-1,0,2))*dir,9 + (gripFrame >= 3));
        }
        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
        break;
    }
    case 3:
    {
        scr_ArmPos(-(26 + (gripFrame >= 1) + 3*(gripFrame >= 2))*dir, 1);
        if(dir == -1)
        {
            scr_ArmPos(-(27 + clamp(gripFrame-1,0,2))*dir, 1);
        }
        break;
    }
    case 4:
    {
        scr_ArmPos(-(26 + gripFrame + (gripFrame >= 2))*dir,-(5 + (gripFrame >= 2)));
        if(dir == -1)
        {
            scr_ArmPos(-(28 + 2*clamp(gripFrame-1,0,2))*dir,-(6 + 2*(gripFrame >= 2)));
        }
        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
        break;
    }
    case 5:
    {
        scr_ArmPos(-(27+ gripFrame)*dir, -(16));
        if(dir == -1)
        {
            scr_ArmPos(-(28 + clamp(gripFrame-1,0,2))*dir, -(17 + (gripFrame >= 3)));
        }
        break;
    }
    case 6:
    {
        scr_ArmPos(-(24+gripFrame)*dir, -21);
        if(dir == -1)
        {
            scr_ArmPos(-(24 + clamp(gripFrame-1,0,2))*dir, -21);
        }
        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
        break;
    }
    case 7:
    {
        scr_ArmPos(-(20 + gripFrame)*dir,-(27 + (gripFrame >= 3)));
        if(dir == -1)
        {
            scr_ArmPos(-(21 + clamp(gripFrame-1,0,2))*dir,-(27 + (gripFrame >= 3)));
        }
        break;
    }
    case 8:
    {
        scr_ArmPos(-(10 + (gripFrame >= 1) + (gripFrame >= 3))*dir, -(30 + (gripFrame >= 2)));
        if(dir == -1)
        {
            scr_ArmPos(-(11 + (gripFrame >= 2))*dir, -(30 + (gripFrame >= 3)));
        }
        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
        break;
    }
    default:
    {
        scr_ArmPos(-(8+gripFrame)*dir, 15+clamp(gripFrame-1,0,2));
        if(dir == -1)
        {
            scr_ArmPos(-(9 + (gripFrame >= 2))*dir, 15 + gripFrame);
        }
        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
        break;
    }
}