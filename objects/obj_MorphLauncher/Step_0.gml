/// @description 

if(global.gamePaused)
{
	exit;
}

var player = instance_place(x,y,obj_Player);
if(state == 0)
{
	frameCounter++;
	if(frameCounter > 12 || frame > 2)
	{
		if(frame <= 0)
		{
			frameNum = 1;
		}
		if(frame >= 2)
		{
			frameNum = -1;
		}
		frame = clamp(frame+frameNum,0,2);
		frameCounter = 0;
	}
	lFrame = frame;
	
	if(instance_exists(player) && player.state == State.Morph && player.grounded && player.velY >= 0 && !player.spiderBall)
	{
		if(place_meeting(x,y,obj_MBBombExplosion))
		{
			//player.shineStart = 30;
			player.shineLauncherStart = 45;//30;
			player.shineRestart = false;
			player.ChangeState(State.BallSpark,State.Morph,mask_Morph,false);
			player.bombJump = 0;
			player.velX = 0;
			player.velY = 0;
			
			audio_play_sound(snd_MorphLauncher,0,false);
			state = 1;
			
			frame = 0;
			frameCounter = 0;
			lFrame = 2;
			lFrameCounter = 0;
		}
	}
}

if(state == 1)
{
	if(frame <= 0)
	{
		frameNum = 1;
	}
	if(frame >= 4)
	{
		frameNum = -1;
	}
	frame = clamp(frame+frameNum,0,4);
	
	if(lFrame <= 2)
	{
		lFrameNum = 1;
	}
	if(lFrame >= 6)
	{
		lFrameNum = -1;
	}
	lFrame = clamp(lFrame+lFrameNum,2,6);
	
	if(instance_exists(player) && player.shineLauncherStart > 0)
	{
		var xx = x,
			yy = y+1;
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
		
		if(choose(1,1,0) == 1 && player.shineLauncherStart > 10)
		{
			with(player)
			{
				var color1 = c_red, color2 = c_yellow;
				var partRange = 32;
				var pX = x+sprtOffsetX, pY = y+sprtOffsetY+runYOffset;
				var part = instance_create_layer(pX+random_range(-partRange,partRange),pY+random_range(-partRange,partRange),"Projectiles_fg",obj_ChargeParticle);
				part.color1 = color1;
				part.color2 = color2;
			}
		}
	}
	else
	{
		state = 0;
		
		frame = 0;
		frameCounter = 0;
		lFrame = 0;
		lFrameCounter = 0;
	}
}