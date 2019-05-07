switch scr_round(aimFrame)
{
	case -4:
	{
		scr_ArmPos((8+(dir == -1))*dir, 19);
		if(recoilCounter > 0)
		{
			armOffsetY -= 1;
		}
		break;
	}
	case -3:
	{
		scr_ArmPos((13+(3*(dir == -1)))*dir, 14+(2*(dir == -1)));
		break;
	}
	case -2:
	{
		scr_ArmPos(20*dir,10);
		if(recoilCounter > 0)
		{
			armOffsetX -= 1*dir;
			armOffsetY -= 1;
		}
		break;
	}
	case -1:
	{
		scr_ArmPos(19*dir, 4 + (dir == -1));
		break;
	}
	case 1:
	{
		scr_ArmPos((20 - (2*(dir == -1)))*dir, -(15 - (2*(dir == -1))));
		break;
	}
	case 2:
	{
		scr_ArmPos(21*dir, -(21 + (dir == -1)));
		if(recoilCounter > 0)
		{
			armOffsetX -= 1*dir;
			armOffsetY += 1;
		}
		break;
	}
	case 3:
	{
		scr_ArmPos(13*dir,-(26 + (dir == -1)));
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