/// @description Logic & Sound

if(!audio_is_playing(snd_XRay_Loop))
{
    if(!xRaySoundPlayed)
    {
        audio_play_sound(snd_XRay,0,false);
        xRaySoundPlayed = true;
    }
    else if(!audio_is_playing(snd_XRay))
    {
        xRaySound = audio_play_sound(snd_XRay_Loop,0,true,1);
		audio_sound_gain(xRaySound,0.375,2000);
    }
}

if(global.pauseState == PauseState.XRay)
{
	var _moveX = clamp(global.controlClustX[INPUT_CLUSTER.VisorMove] + global.controlClustX[INPUT_CLUSTER.PlayerMove], -1,1),
		_moveY = clamp(global.controlClustY[INPUT_CLUSTER.VisorMove] + global.controlClustY[INPUT_CLUSTER.PlayerMove], -1,1);
	var moveDir = point_direction(0,0, _moveX,_moveY),
		moveDist = point_distance(0,0, _moveX,_moveY);
	if(InputPlayerGetDevice() == INPUT_KBM && instance_exists(obj_Mouse)) // && visor uses mouse for control == true
	{
		moveDir = point_direction(x,y, obj_Mouse.PosX_Room(),obj_Mouse.PosY_Room());
		moveDist = 1;
	}
	
	if(moveDist > 0)
	{
		var destAng = scr_round(angle_difference(moveDir, coneDir));
		coneDir += min(abs(destAng), 4 * moveDist) * sign(destAng);
	}
	
	audio_resume_sound(snd_XRay);
	audio_resume_sound(snd_XRay_Loop);
}
else
{
	audio_pause_sound(snd_XRay);
	audio_pause_sound(snd_XRay_Loop);
}

if(!kill)
{
	coneSpread = min(coneSpread + 2, coneSpreadMax);
}
else
{
    coneSpread = max(coneSpread - 2, 0);
    
    if (coneSpread <= 0)
    {
        instance_destroy();
    }
}