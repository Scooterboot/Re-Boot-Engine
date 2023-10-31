function scr_MainInitialize()
{
	application_surface_draw_enable(false); //disable default application surface drawing

	global.gpSlot = -1;			//gamepad slot variable
	global.gpButtonNum = 19;	//number of gamepad buttons variable

	scr_LoadKeyboard();	//load keyboard bindings
	scr_LoadGamepad();	//load gamepad bindings

#region Settings
	ini_open("settings.ini"); //load display, audio, and control settings
	global.HUD = ini_read_real("Controls", "hud style", 0);							//load HUD control setting
	global.aimStyle = ini_read_real("Controls", "aim style", 0);					//load aim control setting
	global.autoDash = ini_read_real("Controls", "auto dash", false);				//load dash control setting
	global.quickClimb = ini_read_real("Controls", "quick climb", true);				//load quick climb control setting

	global.gripStyle = ini_read_real("Controls", "grip control", 0);				//load power grip control setting
	global.grappleStyle = ini_read_real("Controls", "grapple control", 0);			//load grapple beam control setting
	global.spiderBallStyle = ini_read_real("Controls", "spiderball control", 0);	//load spider ball control setting
	global.dodgeStyle = ini_read_real("Controls", "dodge control", 0);				//load dodge control setting


	global.fullScreen = ini_read_real("Display", "fullscreen", false);				//load fullscreen setting
	global.screenScale = ini_read_real("Display", "scale", 3);						//load display scale setting
	global.widescreenEnabled = ini_read_real("Display", "widescreen", false);		//load widescreen setting
	global.vsync = ini_read_real("Display", "vsync", true);							//load vsync setting
	global.upscale = ini_read_real("Display", "upscale", 0);						//load upscale setting
	global.hudDisplay = ini_read_real("Display", "hud display", true);				//load display HUD setting
	global.hudMap = ini_read_real("Display", "hud map", true);						//load display map setting
	global.waterDistortion = ini_read_real("Display", "water distortion", true);	//load water distortion display setting

	global.musicVolume = ini_read_real("Audio", "music", 0.75);						//load music volume config
	global.soundVolume = ini_read_real("Audio", "sound", 0.75);						//load sound volume config
	global.ambianceVolume = ini_read_real("Audio", "ambiance", 0.75);				//load ambiance volume config
	ini_close(); //done loading display, audio, and control settings
#endregion

	global.maxScreenScale = 1;

	global.resWidth = 320;//256;
	global.resHeight = 240;//224;
	
	global.wideResWidth = 426;//400;
	global.ogResWidth = 320;//256;

	global.roomTrans = false;	//variable that checks whether the player is transitioning from room to room
	global.gamePaused = false;	//variable that checks if the game is paused

	global.currentPlayFile = 0; //file that is selected and will be saved over during gameplay

	global.currentPlayTime = 0;
	global.currentItemPercent = 0;
	
	global.cursorGlow = 0;

	global.rmHeated = false;

	randomize(); //randomize seed for various random numbers

	instance_create_depth(0,0,0,obj_PauseMenu);
	instance_create_depth(0,0,0,obj_Particles);
	instance_create_depth(0,0,0,obj_Control);
	instance_create_depth(0,0,0,obj_Audio);
	instance_create_depth(0,0,0,obj_Map);
	instance_create_depth(0,0,0,obj_Progression);
	
	instance_create_depth(0,0,0,obj_TileFadeHandler);
	instance_create_depth(0,0,0,obj_ScreenShaker);

	//room_goto(rm_MainMenu); //go to the main menu
	//instance_create_depth(0,0,0,obj_MainMenu);
	room_goto(rm_Disclaimer);
	
	
	lhc_init();

	lhc_create_interface("IPlayer");

	lhc_create_interface("ISolid");
	lhc_create_interface("INPCSolid");
	lhc_create_interface("IMovingSolid");
	lhc_create_interface("ISlope");
	lhc_create_interface("IPlatform");
	lhc_create_interface("IGrapplePoint");
	lhc_create_interface("IBreakable");
	lhc_create_interface("ISpeedBlock");
	lhc_create_interface("IScrewBlock");

	lhc_assign_interface("IPlayer", obj_Player);

	lhc_assign_interface("ISolid", obj_Tile);
	lhc_assign_interface("INPCSolid", obj_NPCTile, obj_SaveStation);
	lhc_assign_interface("IMovingSolid", obj_MovingTile);
	lhc_assign_interface("ISlope", obj_Slope, obj_Slope_4th, obj_NPCSlope, obj_NPCSlope_4th, obj_MovingSlope, obj_MovingSlope_4th);
	lhc_assign_interface("IPlatform", obj_Platform);//, obj_NPC_MovingPlatform);
	lhc_assign_interface("IGrapplePoint", obj_GrappleBlock, obj_GrappleBlockCracked, obj_PushBlock_Grapple, obj_PushBall_Grapple, obj_GrappleRipper);
	lhc_assign_interface("IBreakable", obj_Breakable);
	lhc_assign_interface("ISpeedBlock", obj_ShotBlock, obj_BombBlock, obj_SpeedBlock);
	lhc_assign_interface("IScrewBlock", obj_ShotBlock, obj_BombBlock, obj_ScrewBlock);
	
	chameleon_init();
}
