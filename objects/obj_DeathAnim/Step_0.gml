var vw = global.resWidth,
	vh = global.resHeight;

var destPosX = vw/2,
    destPosY = vh/2;

if(screenFade[0] >= 1.2)
{
    if(posX != destPosX || posY != destPosY)
    {
        var speedX = max(abs(destPosX - posX)*0.125,1);
        if(posX < destPosX)
        {
            posX = min(posX + speedX, destPosX);
        }
        else
        {
            posX = max(posX - speedX, destPosX);
        }
        
        var speedY = max(abs(posY - destPosY)*0.125,1);
        if(posY < destPosY)
        {
            posY = min(posY + speedY, destPosY);
        }
        else
        {
            posY = max(posY - speedY, destPosY);
        }
    }
}
screenFade[0] = min(screenFade[0] + 0.1, 1.2);

if(!soundPlayed)
{
	if(posX == destPosX && posY == destPosY)
	{
		audio_play_sound(snd_Death,0,false);
		soundPlayed = true;
	}
}

if(soundPlayed)
{
	frameCounter++;
	if(frameCounter > 2)
	{
	    frame = min(frame+1,array_length(animSequence)-1);
	    frameCounter = 0;
	}
}

if(frame > 12)
{
    screenFade[1] = min(screenFade[1] + 0.025, 1.05);
}
if(screenFade[1] >= 1.05 && frame >= array_length(animSequence)-1)
{
    screenFade[2] = min(screenFade[2] + 0.025, 1.05);
}

/*if(screenFade[0] >= 1)
{
    instance_destroy(obj_Player);
    instance_destroy(obj_Camera);
}*/
if(screenFade[2] >= 1.05 && !audio_is_playing(snd_Death))
{
	instance_destroy(obj_Player);
    instance_destroy(obj_Camera);
	
    //room_goto(rm_MainMenu);
    global.gamePaused = false;
    //game_restart();
	scr_LoadGame(global.currentPlayFile);
    instance_destroy();
}