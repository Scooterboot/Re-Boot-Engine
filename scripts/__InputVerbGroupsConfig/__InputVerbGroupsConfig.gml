// Feather disable all

function __InputVerbGroupsConfig()
{
    //Whether verbs should be blocked if *any* of their verb groups are inactive. If you set this macro
    //to `false` then a verb will only be blocked if *all* of its verb groups are inactive.
    #macro INPUT_VERB_GROUP_INACTIVE_ON_ANY  false
    
    enum INPUT_VERB_GROUP
    {
        //EXAMPLE_A,
        //EXAMPLE_B,
        
        //Add your own verb groups here!
		Menu,
		PlayerMovement,
		PlayerActions,
		WeapHUD,
		VisorHUD,
		Visor
    }
    
    //If you add a verb group in the `INPUT_VERB_GROUP` enum then you should add a call to
    //`InputVerbGroupDefine` here.
    //
    // N.B. Any verb not in at least one verb group will be considered as being in every verb group for
    //      the purposes of finding binding collisions.
    
    //InputVerbGroupDefine(INPUT_VERB_GROUP.EXAMPLE_A, [INPUT_VERB.UP, INPUT_VERB.DOWN, INPUT_VERB.LEFT, INPUT_VERB.RIGHT, INPUT_VERB.ACCEPT, INPUT_VERB.CANCEL]);
    //InputVerbGroupDefine(INPUT_VERB_GROUP.EXAMPLE_B, [INPUT_VERB.ACTION, INPUT_VERB.SPECIAL]);
	InputVerbGroupDefine(INPUT_VERB_GROUP.Menu,
	[INPUT_VERB.MenuUp, INPUT_VERB.MenuDown, INPUT_VERB.MenuLeft, INPUT_VERB.MenuRight,
	INPUT_VERB.MenuScrollUp, INPUT_VERB.MenuScrollDown, INPUT_VERB.MenuScrollLeft, INPUT_VERB.MenuScrollRight, INPUT_VERB.MenuScrollHKey,
	INPUT_VERB.Start, INPUT_VERB.MenuAccept, INPUT_VERB.MenuCancel, INPUT_VERB.MenuSecondary,
	INPUT_VERB.MenuR1, INPUT_VERB.MenuR2, INPUT_VERB.MenuL1, INPUT_VERB.MenuL2]);
	
	InputVerbGroupDefine(INPUT_VERB_GROUP.PlayerMovement,
	[INPUT_VERB.PlayerUp, INPUT_VERB.PlayerDown, INPUT_VERB.PlayerLeft, INPUT_VERB.PlayerRight]);
	
	InputVerbGroupDefine(INPUT_VERB_GROUP.PlayerActions,
	[INPUT_VERB.Jump, INPUT_VERB.Fire, INPUT_VERB.Sprint, INPUT_VERB.Dodge,
	INPUT_VERB.InstaShield, INPUT_VERB.Morph, INPUT_VERB.BoostBall, INPUT_VERB.SpiderBall,
	INPUT_VERB.AimUp, INPUT_VERB.AimDown, INPUT_VERB.AimLock, INPUT_VERB.ReverseAim, INPUT_VERB.Moonwalk]);
	
	InputVerbGroupDefine(INPUT_VERB_GROUP.WeapHUD,
	[INPUT_VERB.WeapToggleOn, INPUT_VERB.WeapToggleOff, INPUT_VERB.WeapHUDOpen,
	INPUT_VERB.WeapHUDUp, INPUT_VERB.WeapHUDDown, INPUT_VERB.WeapHUDLeft, INPUT_VERB.WeapHUDRight]);
	
	InputVerbGroupDefine(INPUT_VERB_GROUP.VisorHUD,
	[INPUT_VERB.VisorToggleOn, INPUT_VERB.VisorToggleOff, INPUT_VERB.VisorHUDOpen,
	INPUT_VERB.VisorHUDUp, INPUT_VERB.VisorHUDDown, INPUT_VERB.VisorHUDLeft, INPUT_VERB.VisorHUDRight]);
	
	InputVerbGroupDefine(INPUT_VERB_GROUP.Visor,
	[INPUT_VERB.VisorUse, INPUT_VERB.VisorUp, INPUT_VERB.VisorDown, INPUT_VERB.VisorLeft, INPUT_VERB.VisorRight]);
}