/// @description 
if(global.gamePaused)
{
	exit;
}

if(state != ShipState.Land && state != ShipState.TakeOff)
{
	idleAnim = scr_wrap(idleAnim+4,0,360);
	y = ystart + dsin(idleAnim)*2;
}

block[0].isSolid = false;
block[1].isSolid = false;
block[2].isSolid = false;

block[0].UpdatePosition(x-94,y+44);
block[1].UpdatePosition(x+78,y+44);
block[2].UpdatePosition(x,y);

block[0].isSolid = true;
block[1].isSolid = true;
block[2].isSolid = true;

if(state == ShipState.Idle)
{
	hatchOpen = false;
	movePlayer = false;
	moveY = 0;
	saving = 0;
}

var player = instance_place(x,y,obj_Player);
if (instance_exists(player) && player.state == State.Elevator &&
	abs(player.x - x) <= 10 && !player.grappleActive && !player.isPushing)
{
	if(state == ShipState.SaveDescend)
	{
		player.state = State.Elevator;
		
		if(!movePlayer)
		{
			if(!hatchOpen)
			{
				audio_play_sound(snd_ShipHatch_Open,0,false);
				hatchOpen = true;
			}
			else if(hatchFrame >= 7)
			{
				movePlayer = true;
			}
			
			if(player.position.X < x)
			{
				player.position.X += min(x-player.position.X,1);
			}
			else
			{
				player.position.X += max(x-player.position.X,-1);
			}
			
			var yy = y-18;
			if(player.position.Y < yy)
			{
				player.position.Y += min(yy-player.position.Y,1);
			}
			else
			{
				player.position.Y += max(yy-player.position.Y,-1);
			}
		}
		else
		{
			if(moveY < moveYMax)
			{
				moveY++;
			}
			else
			{
				state = ShipState.SaveAnim;
				audio_play_sound(snd_ShipHatch_Close,0,false);
				hatchOpen = false;
				movePlayer = false;
			}
			
			player.position.X = x;
			player.position.Y = y-18+moveY;
		}
	}
	if(state == ShipState.SaveAnim)
	{
		player.state = State.Elevator;
		player.position.X = x;
		player.position.Y = y-18+moveY;
		
		hatchOpen = false;
		if(hatchFrame <= 0)
		{
			if(saving == 0)
			{
				scr_SaveGame(global.currentPlayFile,x,ystart-18);
				audio_play_sound(snd_Save,0,false);
				obj_UI.CreateMessageBox(gameSavedText,"",Message.Simple);
			}
			if(saving < maxSave)
			{
				saving++;
			}
			else
			{
				state = ShipState.SaveAscend;
				saving = 0;
			}
		}
	}
	if(state == ShipState.SaveAscend)
	{
		player.state = State.Elevator;
		if(!movePlayer)
		{
			if(!hatchOpen)
			{
				audio_play_sound(snd_ShipHatch_Open,0,false);
				hatchOpen = true;
			}
			else if(hatchFrame >= 7)
			{
				movePlayer = true;
			}
		}
		else
		{
			if(moveY > 0)
			{
				moveY--;
			}
			else
			{
				state = ShipState.Idle;
				audio_play_sound(snd_ShipHatch_Close,0,false);
				hatchOpen = false;
				movePlayer = false;
			}
		}
		
		player.position.X = x;
		player.position.Y = y-18+moveY;
	}
	
	player.x = scr_round(player.position.X);
	player.y = scr_round(player.position.Y);
}
else if(state != ShipState.Land && state != ShipState.TakeOff)
{
	state = ShipState.Idle;
}


if(hatchOpen)
{
	if(hatchY > 4)
	{
		hatchY -= 0.5;
	}
	else if(hatchFrame < 7)
	{
		hatchFrameCounter++;
		if(hatchFrameCounter > 3)
		{
			hatchFrame++;
			hatchFrameCounter = 0;
		}
	}
}
else
{
	if(hatchFrame > 0)
	{
		hatchFrameCounter++;
		if(hatchFrameCounter > 3)
		{
			hatchFrame--;
			hatchFrameCounter = 0;
		}
	}
	else if(hatchY < 9)
	{
		hatchY += 0.5;
	}
}