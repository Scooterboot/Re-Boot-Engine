/// @description Main
//discord_update_text("Testing stuff", "Debug Area");
//discord_update_image("brinstarelevator", "smallicon", "Derp", "Made by Scooterboot");

//discord_update();


if (view_camera[0] == -1)
{
	view_camera[0] = camera_create_view(0, 0, global.resWidth, global.resHeight);
}

view_visible[0] = true;
view_enabled = true;

view_set_wport(0,global.resWidth);
view_set_hport(0,global.resHeight);
camera_set_view_size(view_camera[0],global.resWidth,global.resHeight);

global.screenX = (window_get_width() - (surface_get_width(application_surface)*screenScale)) / 2;
global.screenY = (window_get_height() - (surface_get_height(application_surface)*screenScale)) / 2;

if(display_get_width() >= global.resWidth*(global.maxScreenScale+1) && display_get_height() >= global.resHeight*(global.maxScreenScale+1))
{
	global.maxScreenScale += 1;
}
if((display_get_width() < global.resWidth*global.maxScreenScale || display_get_height() < global.resHeight*global.maxScreenScale) && global.maxScreenScale > 1)
{
    global.maxScreenScale -= 1;
}

if(global.screenScale >= 1)
{
	screenScale = global.screenScale;
}
else if(global.screenScale == 0)
{
	screenScale = min(max(window_get_width()/global.resWidth,1),max(window_get_height()/global.resHeight,1));
}

if(!window_get_fullscreen())
{
	window_set_size(global.resWidth*screenScale,global.resHeight*screenScale);
}

if(global.gpSlot != -1)
{
	gamepad_set_axis_deadzone(global.gpSlot, global.gp_deadZone);
}


if(room == rm_MainMenu)
{
	if(instance_exists(obj_Player))
	{
		instance_destroy(obj_Player);
	}
	//if(file selected and stuff)
	//{
		// load game stuff here
		/*room_goto(rm_debug01);
		var sx = 80,
			sy = 694;
		instance_create_layer(sx,sy,"Player",obj_Player);
		instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);*/
	//}
	if(!instance_exists(obj_MainMenu))
	{
		instance_create_depth(0,0,-1,obj_MainMenu);
	}
}
else
{
	if(instance_exists(obj_MainMenu))
	{
		instance_destroy(obj_MainMenu);
	}
}

if(keyboard_check(vk_shift))
{
	room_speed = 2;
}
else
{
	room_speed = 60;
}

if(keyboard_check_pressed(vk_f12))
{
    screen_save_part("screenshot.png",global.screenX,global.screenY,global.resWidth*screenScale,global.resHeight*screenScale);
}

if(room == rm_MainMenu)
{
	// main menu music something something
	
	audio_stop_sound(global.musPrev);
	audio_stop_sound(global.musCurrent);
	audio_stop_sound(global.musNext);
	audio_stop_sound(global.rmMusic);
}
else
{
	if(global.musicVolume > 0)
	{
		global.musNext = global.rmMusic;
		
		if(global.musCurrent != global.musNext)
		{
			if(global.musCurrent != noone)
			{
				audio_sound_gain(global.musCurrent,0,225);
			}
			if(!global.roomTrans)
			{
				if(global.musNext != noone)
				{
					audio_play_sound(global.musNext,1,true);
					audio_sound_gain(global.musNext,global.musicVolume,0);
				}
				global.musPrev = global.musCurrent;
				global.musCurrent = global.musNext;
			}
		}
		
		if(global.musCurrent != noone && !audio_is_playing(global.musCurrent))
		{
			audio_play_sound(global.musCurrent,1,true);
			audio_sound_gain(global.musCurrent,global.musicVolume,0);
		}
	}
	else
	{
		audio_stop_sound(global.musPrev);
		audio_stop_sound(global.musCurrent);
		audio_stop_sound(global.musNext);
		audio_stop_sound(global.rmMusic);
	}
}

if(audio_is_playing(global.musPrev) && audio_sound_get_gain(global.musPrev) <= 0)
{
	audio_stop_sound(global.musPrev);
}

if(global.gamePaused)
{
	audio_pause_sound(snd_Somersault);
	audio_pause_sound(snd_Somersault_Loop);
	audio_pause_sound(snd_Somersault_SJ);
	audio_pause_sound(snd_ScrewAttack);
	audio_pause_sound(snd_ScrewAttack_Loop);
	audio_pause_sound(snd_Charge);
	audio_pause_sound(snd_Charge_Loop);
	audio_pause_sound(snd_SpeedBooster);
	audio_pause_sound(snd_SpeedBooster_Loop);
	audio_pause_sound(snd_ShineSpark);
	audio_pause_sound(snd_ShineSpark_Charge);
	audio_pause_sound(snd_PowerBombExplode);
	audio_pause_sound(snd_SpiderLoop);
	audio_pause_sound(snd_GrappleBeam_Loop);
	audio_pause_sound(snd_Elevator);
	audio_pause_sound(snd_LavaLoop);
	audio_pause_sound(snd_LavaDamageLoop);
	audio_pause_sound(snd_HeatDamageLoop);
}
else
{
	audio_resume_sound(snd_Somersault);
	audio_resume_sound(snd_Somersault_Loop);
	audio_resume_sound(snd_Somersault_SJ);
	audio_resume_sound(snd_ScrewAttack);
	audio_resume_sound(snd_ScrewAttack_Loop);
	audio_resume_sound(snd_Charge);
	audio_resume_sound(snd_Charge_Loop);
	audio_resume_sound(snd_SpeedBooster);
	audio_resume_sound(snd_SpeedBooster_Loop);
	audio_resume_sound(snd_ShineSpark);
	audio_resume_sound(snd_ShineSpark_Charge);
	audio_resume_sound(snd_PowerBombExplode);
	audio_resume_sound(snd_SpiderLoop);
	audio_resume_sound(snd_GrappleBeam_Loop);
	audio_resume_sound(snd_Elevator);
	audio_resume_sound(snd_LavaLoop);
	audio_resume_sound(snd_LavaDamageLoop);
	audio_resume_sound(snd_HeatDamageLoop);
}

global.breakSndCounter = max(global.breakSndCounter-1,0);