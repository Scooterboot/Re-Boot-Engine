application_surface_draw_enable(false); //disable default application surface drawing

global.gpSlot = -1;			//gamepad slot variable
global.gpButtonNum = 19;	//number of gamepad buttons variable

scr_LoadKeyboard();	//load keyboard bindings
scr_LoadGamepad();	//load gamepad bindings

ini_open("settings.ini"); //load display, audio, and control settings
global.aimStyle = ini_read_real("Controls", "aim style", 0);					//load aim control setting
global.spiderBallStyle = ini_read_real("Controls", "spiderball control", 0);	//load spider ball control setting
global.autoDash = ini_read_real("Controls", "auto dash", false);				//load dash control setting
global.quickClimb = ini_read_real("Controls", "quick climb", true);				//load quick climb control setting
global.spinRestart = ini_read_real("Controls", "spin jump restart", true);		//load spin jump restart setting

global.HUD = ini_read_real("Controls", "alt hud", 0);							//load HUD control setting
global.aimOverride = ini_read_real("Controls", "aim override", false);			//load aim override control setting
global.gripStyle = ini_read_real("Controls", "grip control", 0);				//load power grip control setting
global.grappleStyle = ini_read_real("Controls", "grapple control", 0);			//load grapple beam control setting
global.easySJ = ini_read_real("Controls", "space jump control", false);			//load AM2R space jump control setting


global.fullScreen = ini_read_real("Display", "fullscreen", false);				//load fullscreen setting
global.screenScale = ini_read_real("Display", "scale", 3);						//load display scale setting
global.vsync = ini_read_real("Display", "vsync", true);						//load vsync setting
global.upscale = ini_read_real("Display", "upscale", 0);						//load upscale setting
global.hudDisplay = ini_read_real("Display", "hud", true);						//load display HUD setting
global.hudMap = ini_read_real("Display", "hud map", true);						//load display map setting
global.waterDistortion = ini_read_real("Display", "water distortion", true);	//load water distortion display setting

global.musicVolume = ini_read_real("Audio", "music", 1);						//load music volume config
global.soundVolume = ini_read_real("Audio", "sound", 1);						//load sound volume config
ini_close(); //done loading display, audio, and control settings

global.maxScreenScale = 1;

pal_swap_init_system(shd_pal_swapper); //initialize palette swapper system (Created by PixelatedPope)

global.roomTrans = false;	//variable that checks whether the player is transitioning from room to room
global.gamePaused = false;	//variable that checks if the game is paused

//initialize item variables
global.suit[1] = false;
global.misc[5] = false;
global.boots[3] = false;
global.beam[4] = false;
global.item[4] = false;

//initialize map variables

//initialize sound variables
global.prevShotSndIndex = noone;

//initialize music variables

audio_group_load(audio_music);	//load music audio group

audio_group_set_gain(audio_music,global.musicVolume,0);			//set default music volume
audio_group_set_gain(audiogroup_default,global.soundVolume,0);	//set default sound volume

randomize(); //randomize seed for various random numbers

room_goto(rm_MainMenu); //go to the main menu

instance_create_depth(0,0,0,obj_MainMenu);
instance_create_depth(0,0,0,obj_PauseMenu);
instance_create_depth(0,0,0,obj_Particles);
instance_create_depth(0,0,0,obj_Control);