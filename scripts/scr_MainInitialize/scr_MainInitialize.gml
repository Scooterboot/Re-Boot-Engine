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

	pal_swap_init_system(shd_pal_swapper); //initialize palette swapper system (Created by PixelatedPope)

	global.roomTrans = false;	//variable that checks whether the player is transitioning from room to room
	global.gamePaused = false;	//variable that checks if the game is paused

	global.currentPlayFile = 0; //file that is selected and will be saved over during gameplay

	global.currentPlayTime = 0;
	global.currentItemPercent = 0;
	
	global.cursorGlow = 0;

	//initialize room variables

	global.rmHeated = false;

	//initialize sound variables
	global.prevShotSndIndex = noone;
	global.prevExplodeSnd = noone;
	global.breakSndCounter = 0;

	//initialize music variables
	global.rmMusic = noone;

	global.musPrev = noone;
	global.musCurrent = noone;
	global.musNext = noone;


	audio_group_load(audio_music);		//load music audio group
	audio_group_load(audio_sound);		//load sound audio group
	audio_group_load(audio_ambiance);	//load ambiance audio group

	audio_group_set_gain(audio_music,global.musicVolume,0);		//set default music volume
	audio_group_set_gain(audio_sound,global.soundVolume,0);		//set default sound volume
	audio_group_set_gain(audio_ambiance,global.ambianceVolume,0);	//set default sound volume

	randomize(); //randomize seed for various random numbers

	room_goto(rm_MainMenu); //go to the main menu

	instance_create_depth(0,0,0,obj_MainMenu);
	instance_create_depth(0,0,0,obj_PauseMenu);
	instance_create_depth(0,0,0,obj_Particles);
	instance_create_depth(0,0,0,obj_Control);
	instance_create_depth(0,0,0,obj_Music);
	instance_create_depth(0,0,0,obj_Map);
	instance_create_depth(0,0,0,obj_Progression);
	
	instance_create_depth(0,0,0,obj_TileFadeHandler);
}
