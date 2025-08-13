
function InitControlVars(varGroups = undefined)
{
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("menu", varGroups) > 0))
	{
		cStart = false;
		rStart = true;
		
		cMenuUp = false;
		cMenuDown = false;
		cMenuLeft = false;
		cMenuRight = false;
		rMenuUp = true;
		rMenuDown = true;
		rMenuLeft = true;
		rMenuRight = true;
		
		cMenuScrollUp = false;
		cMenuScrollDown = false;
		cMenuScrollLeft = false;
		cMenuScrollRight = false;
		rMenuScrollUp = true;
		rMenuScrollDown = true;
		rMenuScrollLeft = true;
		rMenuScrollRight = true;
		
		cMenuAccept = false;
		cMenuCancel = false;
		cMenuSecondary = false;
		cMenuR1 = false;
		cMenuR2 = false;
		cMenuL1 = false;
		cMenuL2 = false;
		rMenuAccept = true;
		rMenuCancel = true;
		rMenuSecondary = true;
		rMenuR1 = true;
		rMenuR2 = true;
		rMenuL1 = true;
		rMenuL2 = true;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("player", varGroups) > 0))
	{
		cPlayerUp = false;
		cPlayerDown = false;
		cPlayerLeft = false;
		cPlayerRight = false;
		rPlayerUp = true;
		rPlayerDown = true;
		rPlayerLeft = true;
		rPlayerRight = true;
		
		cJump = false;
		cFire = false;
		cSprint = false;
		cDodge = false;
		cInstaShield = false;
		cMorph = false;
		cBoostBall = false;
		cSpiderBall = false;
		rJump = true;
		rFire = true;
		rSprint = true;
		rDodge = true;
		rInstaShield = true;
		rMorph = true;
		rBoostBall = true;
		rSpiderBall = true;
		
		cAimUp = false;
		cAimDown = false;
		cAimLock = false;
		cReverseAim = false;
		cMoonwalk = false;
		rAimUp = true;
		rAimDown = true;
		rAimLock = true;
		rReverseAim = true;
		rMoonwalk = true;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		cVisor = false;
		rVisor = true;
		
		cVisorUp = false;
		cVisorDown = false;
		cVisorLeft = false;
		cVisorRight = false;
		rVisorUp = true;
		rVisorDown = true;
		rVisorLeft = true;
		rVisorRight = true;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		cWeapToggleOn = false;
		cWeapToggleOff = false;
		cWeapHUDOpen = false;
		cWeapHUDUp = false;
		cWeapHUDDown = false;
		cWeapHUDLeft = false;
		cWeapHUDRight = false;
		rWeapToggleOn = true;
		rWeapToggleOff = true;
		rWeapHUDOpen = true;
		rWeapHUDUp = true;
		rWeapHUDDown = true;
		rWeapHUDLeft = true;
		rWeapHUDRight = true;
		
		cVisorToggleOn = false;
		cVisorToggleOff = false;
		cVisorHUDOpen = false;
		cVisorHUDUp = false;
		cVisorHUDDown = false;
		cVisorHUDLeft = false;
		cVisorHUDRight = false;
		rVisorToggleOn = true;
		rVisorToggleOff = true;
		rVisorHUDOpen = true;
		rVisorHUDUp = true;
		rVisorHUDDown = true;
		rVisorHUDLeft = true;
		rVisorHUDRight = true;
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
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		cVisor = global.control[INPUT_VERB.VisorUse];
		
		cVisorUp = global.control[INPUT_VERB.VisorUp];
		cVisorDown = global.control[INPUT_VERB.VisorDown];
		cVisorLeft = global.control[INPUT_VERB.VisorLeft];
		cVisorRight = global.control[INPUT_VERB.VisorRight];
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		cWeapToggleOn = global.control[INPUT_VERB.WeapToggleOn];
		cWeapToggleOff = global.control[INPUT_VERB.WeapToggleOff];
		cWeapHUDOpen = global.control[INPUT_VERB.WeapHUDOpen];
		cWeapHUDUp = global.control[INPUT_VERB.WeapHUDUp];
		cWeapHUDDown = global.control[INPUT_VERB.WeapHUDDown];
		cWeapHUDLeft = global.control[INPUT_VERB.WeapHUDLeft];
		cWeapHUDRight = global.control[INPUT_VERB.WeapHUDRight];
		
		cVisorToggleOn = global.control[INPUT_VERB.VisorToggleOn];
		cVisorToggleOff = global.control[INPUT_VERB.VisorToggleOff];
		cVisorHUDOpen = global.control[INPUT_VERB.VisorHUDOpen];
		cVisorHUDUp = global.control[INPUT_VERB.VisorHUDUp];
		cVisorHUDDown = global.control[INPUT_VERB.VisorHUDDown];
		cVisorHUDLeft = global.control[INPUT_VERB.VisorHUDLeft];
		cVisorHUDRight = global.control[INPUT_VERB.VisorHUDRight];
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
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("visor", varGroups) > 0))
	{
		rVisor = !cVisor;
		
		rVisorUp = !cVisorUp;
		rVisorDown = !cVisorDown;
		rVisorLeft = !cVisorLeft;
		rVisorRight = !cVisorRight;
	}
	if(is_undefined(varGroups) || (is_string(varGroups) && string_pos("hud", varGroups) > 0))
	{
		rWeapToggleOn = !cWeapToggleOn;
		rWeapToggleOff = !cWeapToggleOff;
		rWeapHUDOpen = !cWeapHUDOpen;
		rWeapHUDUp = !cWeapHUDUp;
		rWeapHUDDown = !cWeapHUDDown;
		rWeapHUDLeft = !cWeapHUDLeft;
		rWeapHUDRight = !cWeapHUDRight;
		
		rVisorToggleOn = !cVisorToggleOn;
		rVisorToggleOff = !cVisorToggleOff;
		rVisorHUDOpen = !cVisorHUDOpen;
		rVisorHUDUp = !cVisorHUDUp;
		rVisorHUDDown = !cVisorHUDDown;
		rVisorHUDLeft = !cVisorHUDLeft;
		rVisorHUDRight = !cVisorHUDRight;
	}
}