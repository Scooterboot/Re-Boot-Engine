/// @description Logic
if(global.gamePaused)
{
	exit;
}

if(instance_exists(obj_Player))
{
	var p = obj_Player;
	if(Condition() && p.state == State.Stand && p.y >= y)
	{
		if(place_meeting(x-1,y,p) && p.dir == 1)
		{
			activeDir = -1;
		}
		else if(place_meeting(x+1,y,p) && p.dir == -1)
		{
			activeDir = 1;
		}
	}
	if(activeDir != 0)
	{
		if(!soundPlayed)
		{
			audio_play_sound(snd_InteractStart,0,false);
			soundPlayed = true;
		}
		else if(!audio_is_playing(snd_InteractStart) && !audio_is_playing(snd_InteractLoop))
		{
			audio_play_sound(snd_InteractLoop,0,true);
		}
		
		var offset = 14;
		//p.state = State.Recharge;
		p.ChangeState(State.Recharge,State.Stand,mask_Player_Stand,true,false);
		p.activeStation = id;
		p.dir = -activeDir;
		var xPos = bbox_right+offset;
		if(activeDir == -1)
		{
			xPos = bbox_left-offset;
		}
		if(p.x > xPos)
	    {
	        //p.x = max(p.x-1,xPos);
			p.shiftX = max(xPos-p.x,-1);
	    }
	    if(p.x < xPos)
	    {
	        //p.x = min(p.x+1,xPos);
			p.shiftX = min(xPos-p.x,1);
	    }
		
		if(activeTime >= 10)
		{
			Interact();
		}
		//if(activeTime == activeTimeMax-10)
		if(activeTime == 11)
		{
			//audio_play_sound(snd_Save,0,false);
			obj_UI.CreateMessageBox(stationMessage,"",Message.Simple);
		}
		activeTime++;
		if(activeTime > activeTimeMax)
		{
			audio_stop_sound(snd_InteractStart);
			audio_stop_sound(snd_InteractLoop);
			soundPlayed = false;
			audio_play_sound(snd_InteractEnd,0,false);
			activeDir = 0;
			activeTime = 0;
		}
	}
}
else
{
	activeDir = 0;
	activeTime = 0;
	soundPlayed = false;
}