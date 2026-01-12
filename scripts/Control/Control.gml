
function InitControlVars(varGroups = undefined)
{
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("menu", varGroups) > 0))
	{
		cStart = false;
		rStart = !cStart;
		
		cMenuUp = false;
		cMenuDown = false;
		cMenuLeft = false;
		cMenuRight = false;
		rMenuUp = !cMenuUp;
		rMenuDown = !cMenuDown;
		rMenuLeft = !cMenuLeft;
		rMenuRight = !cMenuRight;
		
		cMenuScrollUp = false;
		cMenuScrollDown = false;
		cMenuScrollLeft = false;
		cMenuScrollRight = false;
		rMenuScrollUp = !cMenuScrollUp;
		rMenuScrollDown = !cMenuScrollDown;
		rMenuScrollLeft = !cMenuScrollLeft;
		rMenuScrollRight = !cMenuScrollRight;
		
		cMenuAccept = false;
		cMenuCancel = false;
		cMenuSecondary = false;
		cMenuTertiary = false;
		cMenuR1 = false;
		cMenuR2 = false;
		cMenuL1 = false;
		cMenuL2 = false;
		rMenuAccept = !cMenuAccept;
		rMenuCancel = !cMenuCancel;
		rMenuSecondary = !cMenuSecondary;
		rMenuTertiary = !cMenuTertiary;
		rMenuR1 = !cMenuR1;
		rMenuR2 = !cMenuR2;
		rMenuL1 = !cMenuL1;
		rMenuL2 = !cMenuL2;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("player", varGroups) > 0))
	{
		cPlayerUp = false;
		cPlayerDown = false;
		cPlayerLeft = false;
		cPlayerRight = false;
		rPlayerUp = !cPlayerUp;
		rPlayerDown = !cPlayerDown;
		rPlayerLeft = !cPlayerLeft;
		rPlayerRight = !cPlayerRight;
		
		cJump = false;
		cFire = false;
		cSprint = false;
		cDodge = false;
		cInstaShield = false;
		cMorph = false;
		cBoostBall = false;
		cSpiderBall = false;
		rJump = !cJump;
		rFire = !cFire;
		rSprint = !cSprint;
		rDodge = !cDodge;
		rInstaShield = !cInstaShield;
		rMorph = !cMorph;
		rBoostBall = !cBoostBall;
		rSpiderBall = !cSpiderBall;
		
		cAimUp = false;
		cAimDown = false;
		cAimLock = false;
		cReverseAim = false;
		cMoonwalk = false;
		rAimUp = !cAimUp;
		rAimDown = !cAimDown;
		rAimLock = !cAimLock;
		rReverseAim = !cReverseAim;
		rMoonwalk = !cMoonwalk;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		cEquipToggle = false;
		rEquipToggle = !cEquipToggle;
		
		cVisorToggle = false;
		rVisorToggle = !cVisorToggle;
		cVisorCycle = false;
		rVisorCycle = !cVisorCycle;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("radial", varGroups) > 0))
	{
		cRadialUIOpen = false;
		cRadialUIUp = false;
		cRadialUIDown = false;
		cRadialUILeft = false;
		cRadialUIRight = false;
		rRadialUIOpen = !cRadialUIOpen;
		rRadialUIUp = !cRadialUIUp;
		rRadialUIDown = !cRadialUIDown;
		rRadialUILeft = !cRadialUILeft;
		rRadialUIRight = !cRadialUIRight;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		cVisorUse = false;
		rVisorUse = !cVisorUse;
		
		cVisorUp = false;
		cVisorDown = false;
		cVisorLeft = false;
		cVisorRight = false;
		rVisorUp = !cVisorUp;
		rVisorDown = !cVisorDown;
		rVisorLeft = !cVisorLeft;
		rVisorRight = !cVisorRight;
	}
}
function SetControlVars(varGroups = undefined)
{
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("menu", varGroups) > 0))
	{
		cStart = global.control[INPUT_VERB.Start];
		
		cMenuUp = global.control[INPUT_VERB.MenuUp];
		cMenuDown = global.control[INPUT_VERB.MenuDown];
		cMenuLeft = global.control[INPUT_VERB.MenuLeft];
		cMenuRight = global.control[INPUT_VERB.MenuRight];
		
		cMenuScrollUp = global.control[INPUT_VERB.MenuScrollUp];
		cMenuScrollDown = global.control[INPUT_VERB.MenuScrollDown];
		cMenuScrollLeft = global.control[INPUT_VERB.MenuScrollLeft];
		cMenuScrollRight = global.control[INPUT_VERB.MenuScrollRight];
		
		cMenuAccept = global.control[INPUT_VERB.MenuAccept];
		cMenuCancel = global.control[INPUT_VERB.MenuCancel];
		cMenuSecondary = global.control[INPUT_VERB.MenuSecondary];
		cMenuTertiary = global.control[INPUT_VERB.MenuTertiary];
		cMenuR1 = global.control[INPUT_VERB.MenuR1];
		cMenuR2 = global.control[INPUT_VERB.MenuR2];
		cMenuL1 = global.control[INPUT_VERB.MenuL1];
		cMenuL2 = global.control[INPUT_VERB.MenuL2];
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("player", varGroups) > 0))
	{
		cPlayerUp = global.control[INPUT_VERB.PlayerUp];
		cPlayerDown = global.control[INPUT_VERB.PlayerDown];
		cPlayerLeft = global.control[INPUT_VERB.PlayerLeft];
		cPlayerRight = global.control[INPUT_VERB.PlayerRight];
		
		cJump = global.control[INPUT_VERB.Jump];
		cFire = global.control[INPUT_VERB.Fire];
		cSprint = global.control[INPUT_VERB.Sprint];
		cDodge = global.control[INPUT_VERB.Dodge];
		cInstaShield = global.control[INPUT_VERB.InstaShield];
		cMorph = global.control[INPUT_VERB.Morph];
		cBoostBall = global.control[INPUT_VERB.BoostBall];
		cSpiderBall = global.control[INPUT_VERB.SpiderBall];
		
		cAimUp = global.control[INPUT_VERB.AimUp];
		cAimDown = global.control[INPUT_VERB.AimDown];
		cAimLock = global.control[INPUT_VERB.AimLock];
		cReverseAim = global.control[INPUT_VERB.ReverseAim];
		cMoonwalk = global.control[INPUT_VERB.Moonwalk];
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		cEquipToggle = global.control[INPUT_VERB.EquipToggle];
		
		cVisorToggle = global.control[INPUT_VERB.VisorToggle];
		cVisorCycle = global.control[INPUT_VERB.VisorCycle];
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("radial", varGroups) > 0))
	{
		cRadialUIOpen = global.control[INPUT_VERB.RadialUIOpen];
		cRadialUIUp = global.control[INPUT_VERB.RadialUIUp];
		cRadialUIDown = global.control[INPUT_VERB.RadialUIDown];
		cRadialUILeft = global.control[INPUT_VERB.RadialUILeft];
		cRadialUIRight = global.control[INPUT_VERB.RadialUIRight];
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		cVisorUse = global.control[INPUT_VERB.VisorUse];
		
		cVisorUp = global.control[INPUT_VERB.VisorUp];
		cVisorDown = global.control[INPUT_VERB.VisorDown];
		cVisorLeft = global.control[INPUT_VERB.VisorLeft];
		cVisorRight = global.control[INPUT_VERB.VisorRight];
	}
}
function SetReleaseVars(varGroups = undefined)
{
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("menu", varGroups) > 0))
	{
		rStart = !cStart;
		
		rMenuUp = !cMenuUp;
		rMenuDown = !cMenuDown;
		rMenuLeft = !cMenuLeft;
		rMenuRight = !cMenuRight;
		
		rMenuScrollUp = !cMenuScrollUp;
		rMenuScrollDown = !cMenuScrollDown;
		rMenuScrollLeft = !cMenuScrollLeft;
		rMenuScrollRight = !cMenuScrollRight;
		
		rMenuAccept = !cMenuAccept;
		rMenuCancel = !cMenuCancel;
		rMenuSecondary = !cMenuSecondary;
		rMenuTertiary = !cMenuTertiary;
		rMenuR1 = !cMenuR1;
		rMenuR2 = !cMenuR2;
		rMenuL1 = !cMenuL1;
		rMenuL2 = !cMenuL2;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("player", varGroups) > 0))
	{
		rPlayerUp = !cPlayerUp;
		rPlayerDown = !cPlayerDown;
		rPlayerLeft = !cPlayerLeft;
		rPlayerRight = !cPlayerRight;
		
		rJump = !cJump;
		rFire = !cFire;
		rSprint = !cSprint;
		rDodge = !cDodge;
		rInstaShield = !cInstaShield;
		rMorph = !cMorph;
		rBoostBall = !cBoostBall;
		rSpiderBall = !cSpiderBall;
		
		rAimUp = !cAimUp;
		rAimDown = !cAimDown;
		rAimLock = !cAimLock;
		rReverseAim = !cReverseAim;
		rMoonwalk = !cMoonwalk;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		rEquipToggle = !cEquipToggle;
		
		rVisorToggle = !cVisorToggle;
		rVisorCycle = !cVisorCycle;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("radial", varGroups) > 0))
	{
		rRadialUIOpen = !cRadialUIOpen;
		rRadialUIUp = !cRadialUIUp;
		rRadialUIDown = !cRadialUIDown;
		rRadialUILeft = !cRadialUILeft;
		rRadialUIRight = !cRadialUIRight;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		rVisorUse = !cVisorUse;
		
		rVisorUp = !cVisorUp;
		rVisorDown = !cVisorDown;
		rVisorLeft = !cVisorLeft;
		rVisorRight = !cVisorRight;
	}
}