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

block.isSolid = false;
block.UpdatePosition(x,y);
block.isSolid = true;

if(state == ShipState.Idle)
{
	hatchOpen = false;
	movePlayer = false;
	moveY = 0;
	saving = -20;
}

var xx = x,
	yy = y-17;

var player = instance_place(x,y,obj_Player);
if (instance_exists(player) && player.state == State.Elevator &&
	abs(player.x - x) <= 10 && !instance_exists(player.grapple) && !player.isPushing)
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
			
			player.position.X = xx;
			player.position.Y = yy+moveY;
		}
	}
	if(state == ShipState.SaveAnim)
	{
		player.state = State.Elevator;
		player.position.X = xx;
		player.position.Y = yy+moveY;
		
		hatchOpen = false;
		if(saving < 0)
		{
			var eMax = player.energyMax,
				mMax = player.missileMax,
				sMax = player.superMissileMax,
				pMax = player.powerBombMax;
			player.energy = clamp(lerp(player.energy,eMax,0.25), player.energy+(eMax/20), eMax);
			player.missileStat = clamp(lerp(player.missileStat,mMax,0.25), player.missileStat+(mMax/20), mMax);
			player.superMissileStat = clamp(lerp(player.superMissileStat,sMax,0.25), player.superMissileStat+(sMax/20), sMax);
			player.powerBombStat = clamp(lerp(player.powerBombStat,pMax,0.25), player.powerBombStat+(pMax/20), pMax);
			saving++;
		}
		else if(hatchFrame <= 0)
		{
			if(saving == 0)
			{
				// make sure these are maxed because why not
				player.energy = player.energyMax;
				player.missileStat = player.missileMax;
				player.superMissileStat = player.superMissileMax;
				player.powerBombStat = player.powerBombMax;
				
				UpdateMapIcon();
				
				scr_SaveGame(global.currentPlayFile,x,ystart-18);
				audio_play_sound(snd_Save,0,false);
				obj_UI_Old.CreateMessageBox(gameSavedText,"",Message.Simple);
			}
			if(saving < maxSave)
			{
				saving++;
			}
			else
			{
				state = ShipState.SaveAscend;
				saving = -20;
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
				moveY = 0;
			}
		}
		
		player.position.X = xx;
		player.position.Y = yy+moveY;
	}
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

if(lightGlowNum == 1)
{
	lightGlow = min(lightGlow+0.025,1);
	if(lightGlow >= 1)
	{
		lightGlowNum = -1;
	}
}
else
{
	lightGlow = max(lightGlow-0.025,0);
	if(lightGlow <= 0)
	{
		lightGlowNum = 1;
	}
}

var vlSpd = 0.005,
	vlMax = 0.35;
if(state == ShipState.SaveAnim && saving > 0)
{
	vlSpd = 0.075;
	vlMax = 0.8;
}
else if(visorLightGlow > vlMax)
{
	vlSpd = 0.075;
}

if(visorLightGlowNum == 1)
{
	if(visorLightGlow >= vlMax)
	{
		visorLightGlowNum = -1;
	}
	else
	{
		visorLightGlow = min(visorLightGlow+vlSpd,vlMax);
	}
}
else
{
	visorLightGlow = max(visorLightGlow-vlSpd,0);
	if(visorLightGlow <= 0)
	{
		visorLightGlowNum = 1;
	}
}