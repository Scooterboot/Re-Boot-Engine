/// @description Sound & Animation
if(instance_exists(obj_MainMenu) && obj_MainMenu.currentScreen != MainScreen.TitleIntro && obj_MainMenu.currentScreen != MainScreen.Title)
{
	exit;
}

/*if(counter2 > 0)
{
    image_index = 3;
    if(counter3 > 0)
    {
        frameSpeed = 3;
    }
    else
    {
        frameSpeed = 8;
    }
}
else
{
    image_index = 0;
    frameSpeed = 8;
}

frameCounter++;
if(frameCounter > frameSpeed)
{
    frame += num;
    frameCounter = 0;
}
if(frame >= frameMax - 1)
{
    num = -1;
}
if(frame <= 0)
{
    num = 1;
}
counter += 1;
switch(counter)
{
    case 60:
    {
        snd = audio_play_sound(snd_MetroidScree0,0,false);
        counter2 = audio_sound_length(snd)*60;
        counter3 = audio_sound_length(snd)*30;
        break;
    }
    case 200:
    {
        snd = audio_play_sound(snd_MetroidScree1,0,false);
        counter2 = audio_sound_length(snd)*60;
        counter3 = audio_sound_length(snd)*30;
        break;
    }
    case 400:
    {
        snd = audio_play_sound(snd_MetroidScree2,0,false);
        counter2 = audio_sound_length(snd)*60;
        counter3 = audio_sound_length(snd)*30;
        break;
    }
    default: break;
}
if(counter > 500)
{
    counter = 0;
}
counter2 = max(counter2 - 1, 0);
counter3 = max(counter3 - 1, 0);

image_index += frame;*/

if(screeDelay <= 0)
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
    frame += num;
    frameCounter = 0;
}
if(frame >= 2)
{
    num = -1;
}
if(frame <= 0)
{
    num = 1;
}

if(screeDur1 <= 0)
{
	screeDelay = max(screeDelay - 1, 0);
}
screeDur1 = max(screeDur1 - 1, 0);
screeDur2 = max(screeDur2 - 1, 0);

image_index = frameState + frame;
