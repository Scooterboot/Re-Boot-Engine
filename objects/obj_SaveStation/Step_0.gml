/// @description Check for player & save

if(global.gamePaused)
{
	exit;
}

if(instance_exists(obj_Player) && place_meeting(x,y,obj_Player) && 
	(obj_Player.state == State.Stand || obj_Player.state == State.Elevator) &&
	obj_Player.grounded && abs(obj_Player.x - x) < 12)
{
	if(saveCooldown <= 0)
	{
		if(saving <= 0)
		{
			if(obj_Player.dir == 0)
			{
				saveCooldown = 60;
			}
			else
			{
				beginSave++;
				if(beginSave > 30)
				{
					saving = maxSave;
				}
			}
		}
		else
		{
			var xx = x,
				yy = bbox_bottom-41;
			if(saving == maxSave)
			{
				obj_Player.state = State.Elevator;
				obj_Player.saveAnimCounter = maxSave;
				scr_SaveGame(global.currentPlayFile,xx,yy);
				audio_play_sound(snd_Save,0,false);
				obj_UI.CreateMessageBox(gameSavedText,"",Message.Simple);
			}
			
			if(obj_Player.x < xx)
			{
				obj_Player.x = min(obj_Player.x+1,xx);
			}
			else
			{
				obj_Player.x = max(obj_Player.x-1,xx);
			}
			if(obj_Player.y < yy)
			{
				obj_Player.y = min(obj_Player.y+1,yy);
			}
			else
			{
				obj_Player.y = max(obj_Player.y-1,yy);
			}
		
			saving--;
		}
	}
	else
	{
		saving = 0;
	}
}
else
{
	beginSave = 0;
	saving = 0;
	if(!place_meeting(x,y,obj_Player) || saveCooldown < 60)
	{
		saveCooldown = max(saveCooldown-1,0);
	}
}

if(saving > 0)
{
	image_speed = 1;
}
else
{
	image_speed = 0;
	image_index = 0;
}


if(instance_exists(back))
{
	back.image_index = image_index;
}