
function __InputConfigVerbs()
{
	// do i have too many buttons? idk. it's probably fiiiine
	enum INPUT_VERB
	{
		MenuUp,
		MenuDown,
		MenuLeft,
		MenuRight,
		MenuScrollUp,
		MenuScrollDown,
		MenuScrollLeft,
		MenuScrollRight,
	
		Start,
		MenuAccept,
		MenuCancel,
		MenuSecondary,
		MenuR1,
		MenuR2,
		MenuL1,
		MenuL2,
	
		PlayerUp,
		PlayerDown,
		PlayerLeft,
		PlayerRight,
	
		Jump,
		Fire,
		Sprint,
		Dodge,
		InstaShield,
		Morph,
		BoostBall,
		SpiderBall,
	
		AimUp,
		AimDown,
		AimLock,
		ReverseAim,
		Moonwalk,
		
		VisorUse,
		VisorUp,
		VisorDown,
		VisorLeft,
		VisorRight,
	
		WeapToggleOn,
		WeapToggleOff,
		WeapHUDOpen,
		WeapHUDUp,
		WeapHUDDown,
		WeapHUDLeft,
		WeapHUDRight,
		
		VisorToggleOn,
		VisorToggleOff,
		VisorHUDOpen,
		VisorHUDUp,
		VisorHUDDown,
		VisorHUDLeft,
		VisorHUDRight,
	
		_Length
	}
	enum INPUT_CLUSTER
	{
		MenuMove,
		MenuScroll,
		PlayerMove,
		WeapHUDMove,
		VisorHUDMove,
		VisorMove
	}
	
	var _gp_face1 = gp_face1,
		_gp_face2 = gp_face2;
	if(INPUT_ON_SWITCH)
	{
		_gp_face1 = gp_face2;
		_gp_face2 = gp_face1;
	}
	
	// i have no idea what constitutes as a 'good' keyboard control scheme
	// so imma just throw some shit up and hope people will suggest better default schemes
	
	InputDefineVerb(INPUT_VERB.MenuUp,		"menu up",		vk_up,		[-gp_axislv, gp_padu]);
	InputDefineVerb(INPUT_VERB.MenuDown,	"menu down",	vk_down,	[ gp_axislv, gp_padd]);
	InputDefineVerb(INPUT_VERB.MenuLeft,	"menu left",	vk_left,	[-gp_axislh, gp_padl]);
	InputDefineVerb(INPUT_VERB.MenuRight,	"menu right",	vk_right,	[ gp_axislh, gp_padr]);
	InputDefineCluster(INPUT_CLUSTER.MenuMove, INPUT_VERB.MenuUp, INPUT_VERB.MenuRight, INPUT_VERB.MenuDown, INPUT_VERB.MenuLeft);
	
	InputDefineVerb(INPUT_VERB.MenuScrollUp,	"menu scroll up",		[mb_wheel_up, vk_shift],	-gp_axisrv);
	InputDefineVerb(INPUT_VERB.MenuScrollDown,	"menu scroll down",		[mb_wheel_down, vk_shift],	 gp_axisrv);
	InputDefineVerb(INPUT_VERB.MenuScrollLeft,	"menu scroll left",		[mb_wheel_up, vk_shift],	-gp_axisrh);
	InputDefineVerb(INPUT_VERB.MenuScrollRight,	"menu scroll right",	[mb_wheel_down, vk_shift],	 gp_axisrh);
	InputDefineCluster(INPUT_CLUSTER.MenuScroll, INPUT_VERB.MenuScrollUp, INPUT_VERB.MenuScrollRight, INPUT_VERB.MenuScrollDown, INPUT_VERB.MenuScrollLeft);
	
	InputDefineVerb(INPUT_VERB.Start,			"start",			vk_enter,	gp_start);
	InputDefineVerb(INPUT_VERB.MenuAccept,		"menu accept",		ord("Z"),	_gp_face1);
	InputDefineVerb(INPUT_VERB.MenuCancel,		"menu cancel",		ord("X"),	[_gp_face2, gp_face3]);
	InputDefineVerb(INPUT_VERB.MenuSecondary,	"menu secondary",	ord("C"),	gp_face4);
	InputDefineVerb(INPUT_VERB.MenuR1,			"menu r1",			ord("E"),	gp_shoulderr);
	InputDefineVerb(INPUT_VERB.MenuR2,			"menu r2",			ord("D"),	gp_shoulderrb);
	InputDefineVerb(INPUT_VERB.MenuL1,			"menu l1",			ord("Q"),	gp_shoulderl);
	InputDefineVerb(INPUT_VERB.MenuL2,			"menu l2",			ord("A"),	gp_shoulderlb);
	
	InputDefineVerb(INPUT_VERB.PlayerUp,	"player up",	vk_up,		gp_padu);
	InputDefineVerb(INPUT_VERB.PlayerDown,	"player down",	vk_down,	gp_padd);
	InputDefineVerb(INPUT_VERB.PlayerLeft,	"player left",	vk_left,	gp_padl);
	InputDefineVerb(INPUT_VERB.PlayerRight,	"player right",	vk_right,	gp_padr);
	InputDefineCluster(INPUT_CLUSTER.PlayerMove, INPUT_VERB.PlayerUp, INPUT_VERB.PlayerRight, INPUT_VERB.PlayerDown, INPUT_VERB.PlayerLeft);
	
	InputDefineVerb(INPUT_VERB.Jump,		"jump",			ord("Z"),				gp_face1);
	InputDefineVerb(INPUT_VERB.Fire,		"fire",			ord("X"),				gp_face3);
	InputDefineVerb(INPUT_VERB.Sprint,		"sprint",		ord("C"),				gp_face2);
	InputDefineVerb(INPUT_VERB.Dodge,		"dodge",		vk_lshift,				gp_face4);
	InputDefineVerb(INPUT_VERB.InstaShield, "instashield",	ord("C"),				gp_face2);
	InputDefineVerb(INPUT_VERB.Morph,		"morph",		ord("V"),				gp_shoulderr);
	InputDefineVerb(INPUT_VERB.BoostBall,	"boost ball",	ord("C"),				gp_face2);
	InputDefineVerb(INPUT_VERB.SpiderBall,	"spider ball",	[ord("A"), ord("S")],	[gp_shoulderlb, gp_shoulderrb]);
	
	InputDefineVerb(INPUT_VERB.AimUp,		"aim up",		ord("S"),				gp_shoulderrb);
	InputDefineVerb(INPUT_VERB.AimDown,		"aim down",		ord("A"),				gp_shoulderlb);
	InputDefineVerb(INPUT_VERB.AimLock,		"aim lock",		[ord("S"), ord("A")],	[gp_shoulderrb, gp_shoulderlb]);
	InputDefineVerb(INPUT_VERB.ReverseAim,	"reverse aim",	ord("D"),				gp_shoulderl);
	InputDefineVerb(INPUT_VERB.Moonwalk,	"moonwalk",		ord("F"),				gp_shoulderl);
	
	InputDefineVerb(INPUT_VERB.VisorUse,	"visor",		mb_left,	gp_stickr);
	InputDefineVerb(INPUT_VERB.VisorUp,		"visor up",		undefined,	-gp_axisrv);
	InputDefineVerb(INPUT_VERB.VisorDown,	"visor down",	undefined,	 gp_axisrv);
	InputDefineVerb(INPUT_VERB.VisorLeft,	"visor left",	undefined,	-gp_axisrh);
	InputDefineVerb(INPUT_VERB.VisorRight,	"visor right",	undefined,	 gp_axisrh);
	InputDefineCluster(INPUT_CLUSTER.VisorMove, INPUT_VERB.VisorUp, INPUT_VERB.VisorRight, INPUT_VERB.VisorDown, INPUT_VERB.VisorLeft);
	
	InputDefineVerb(INPUT_VERB.WeapToggleOn,	"weap toggle on",	ord("R"),	gp_stickr);
	InputDefineVerb(INPUT_VERB.WeapToggleOff,	"weap toggle off",	ord("R"),	gp_stickr);
	InputDefineVerb(INPUT_VERB.WeapHUDOpen,		"weap hud open",	ord("E"),	[gp_axisrh, -gp_axisrh, gp_axisrv, -gp_axisrv]);
	InputDefineVerb(INPUT_VERB.WeapHUDUp,		"weap hud up",		vk_up,		-gp_axisrv);
	InputDefineVerb(INPUT_VERB.WeapHUDDown,		"weap hud down",	vk_down,	 gp_axisrv);
	InputDefineVerb(INPUT_VERB.WeapHUDLeft,		"weap hud left",	vk_left,	-gp_axisrh);
	InputDefineVerb(INPUT_VERB.WeapHUDRight,	"weap hud right",	vk_right,	 gp_axisrh);
	InputDefineCluster(INPUT_CLUSTER.WeapHUDMove, INPUT_VERB.WeapHUDUp, INPUT_VERB.WeapHUDRight, INPUT_VERB.WeapHUDDown, INPUT_VERB.WeapHUDLeft);
	
	InputDefineVerb(INPUT_VERB.VisorToggleOn,	"visor toggle on",	ord("Q"),	gp_stickl);
	InputDefineVerb(INPUT_VERB.VisorToggleOff,	"visor toggle off",	ord("Q"),	gp_stickl);
	InputDefineVerb(INPUT_VERB.VisorHUDOpen,	"visor hud open",	vk_tab,		[gp_axislh, -gp_axislh, gp_axislv, -gp_axislv]);
	InputDefineVerb(INPUT_VERB.VisorHUDUp,		"visor hud up",		vk_up,		-gp_axislv);
	InputDefineVerb(INPUT_VERB.VisorHUDDown,	"visor hud down",	vk_down,	 gp_axislv);
	InputDefineVerb(INPUT_VERB.VisorHUDLeft,	"visor hud left",	vk_left,	-gp_axislh);
	InputDefineVerb(INPUT_VERB.VisorHUDRight,	"visor hud right",	vk_right,	 gp_axislh);
	InputDefineCluster(INPUT_CLUSTER.VisorHUDMove, INPUT_VERB.VisorHUDUp, INPUT_VERB.VisorHUDRight, INPUT_VERB.VisorHUDDown, INPUT_VERB.VisorHUDLeft);
}

/*function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        UP,
        DOWN,
        LEFT,
        RIGHT,
        ACCEPT,
        CANCEL,
        ACTION,
        SPECIAL,
        PAUSE,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    if (not INPUT_ON_SWITCH)
    {
        InputDefineVerb(INPUT_VERB.UP,      "up",         [vk_up,    "W"],    [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,    "down",       [vk_down,  "S"],    [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,    "left",       [vk_left,  "A"],    [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,   "right",      [vk_right, "D"],    [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.ACCEPT,  "accept",      vk_space,            gp_face1);
        InputDefineVerb(INPUT_VERB.CANCEL,  "cancel",      vk_backspace,        gp_face2);
        InputDefineVerb(INPUT_VERB.ACTION,  "action",      vk_enter,            gp_face3);
        InputDefineVerb(INPUT_VERB.SPECIAL, "special",     vk_shift,            gp_face4);
        InputDefineVerb(INPUT_VERB.PAUSE,   "pause",       vk_escape,           gp_start);
    }
    else //Flip A/B over on Switch
    {
        InputDefineVerb(INPUT_VERB.UP,      "up",      undefined, [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,    "down",    undefined, [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,    "left",    undefined, [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,   "right",   undefined, [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.ACCEPT,  "accept",  undefined,   gp_face2); // !!
        InputDefineVerb(INPUT_VERB.CANCEL,  "cancel",  undefined,   gp_face1); // !!
        InputDefineVerb(INPUT_VERB.ACTION,  "action",  undefined,   gp_face3);
        InputDefineVerb(INPUT_VERB.SPECIAL, "special", undefined,   gp_face4);
        InputDefineVerb(INPUT_VERB.PAUSE,   "pause",   undefined,   gp_start);
    }
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}*/
