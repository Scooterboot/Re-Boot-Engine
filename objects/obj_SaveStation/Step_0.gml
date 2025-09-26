/// @description Check for player & save

if(global.GamePaused())
{
	exit;
}

var bbottom = bbox_bottom-1;

var player = instance_place(x,y,obj_Player);
if (instance_exists(player) && (player.state == State.Stand || player.state == State.Elevator) &&
	abs(player.x - x) < 12 && player.bb_bottom() < bbottom+1 && player.bb_bottom() > bbottom-1 && 
	player.grounded && !instance_exists(player.grapple) && !player.isPushing)
{
	if(saveCooldown <= 0)
	{
		if(saving <= 0)
		{
			if(player.dir == 0)
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
				yy = bbottom-25;
			if(saving == maxSave)
			{
				UpdateMapIcon();
				
				player.state = State.Elevator;
				player.saveAnimCounter = maxSave;
				scr_SaveGame(global.currentPlayFile,xx,yy);
				audio_play_sound(snd_Save,0,false);
				obj_UI_Old.CreateMessageBox(gameSavedText,"",Message.Simple);
			}
			
			if(player.position.X < xx)
			{
				player.shiftX = min(xx-player.position.X,1);
			}
			else
			{
				player.shiftX = max(xx-player.position.X,-1);
			}
			if(player.position.Y < yy)
			{
				player.shiftY = min(yy-player.position.Y,1);
			}
			else
			{
				player.shiftY = max(yy-player.position.Y,-1);
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