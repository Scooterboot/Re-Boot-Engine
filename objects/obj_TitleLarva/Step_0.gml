/// @description Sound & Animation
if(instance_exists(obj_MainMenu) && obj_MainMenu.currentScreen != MainScreen.TitleIntro && obj_MainMenu.currentScreen != MainScreen.Title)
{
	exit;
}

if(screeDelay <= 0) && false // temp disabled
{
	var snd;
	switch(irandom(2))
	{
		case 2:
		{
			snd = audio_play_sound(snd_MetroidScree2,0,false);
			break;
		}
		case 1:
		{
			snd = audio_play_sound(snd_MetroidScree1,0,false);
			break;
		}
		default:
		{
			snd = audio_play_sound(snd_MetroidScree0,0,false);
			break;
		}
	}
	if(audio_is_playing(snd))
	{
		screeDur1 = audio_sound_length(snd)*60;
        screeDur2 = audio_sound_length(snd)*30;
	}
	screeDelay = irandom_range(100,200);
}

if(screeDur1 > 0)
{
	frameState = 3;
}
else
{
	frameState = 0;
}
if(screeDur2 > 0)
{
	frameSpeed = 3;
}
else
{
	frameSpeed = 8;
}

frameCounter++;
if(frameCounter > frameSpeed)
{
    frame += frameNum;
    frameCounter = 0;
}
if(frame >= 2)
{
    frameNum = -1;
}
if(frame <= 0)
{
    frameNum = 1;
}

if(screeDur1 <= 0)
{
	screeDelay = max(screeDelay - 1, 0);
}
screeDur1 = max(screeDur1 - 1, 0);
screeDur2 = max(screeDur2 - 1, 0);

image_index = frameState + frame;
