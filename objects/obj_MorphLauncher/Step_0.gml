/// @description 

if(global.GamePaused())
{
	exit;
}

var player = instance_place(x,y,obj_Player);
if(state == 0)
{
	if(frameFinal > 2)
	{
		frameFinal--;
		frame = 2;
	}
	else
	{
		frameCounter++;
		if(frameCounter > 12)
		{
			frame = scr_wrap(frame+1,0,4);
			frameCounter = 0;
		}
		frameFinal = frameSeq[frame];
	}
	lFrameFinal = frameFinal;
	
	if(instance_exists(player) && player.state == State.Morph && player.grounded && player.velY >= 0 && !player.SpiderActive())
	{
		if(place_meeting(x,y,obj_MBBombExplosion))
		{
			//player.shineStart = 30;
			player.shineLauncherStart = 45;//30;
			player.shineRestart = false;
			player.ChangeState(State.BallSpark,State.Morph,mask_Player_Morph,false);
			player.bombJump = 0;
			player.velX = 0;
			player.velY = 0;
			
			audio_play_sound(snd_MorphLauncher,0,false);
			state = 1;
			stateCounter = player.shineLauncherStart;
			
			frameCounter = 0;
		}
	}
}

if(state == 1)
{
	frame = scr_wrap(frame+1,0,8);
	frameFinal = frameSeq2[frame];
	lFrameFinal = lFrameSeq[frame];
	
	if(instance_exists(player) && player.state == State.BallSpark && player.shineLauncherStart > 0)
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
	
	if(stateCounter > 0)
	{
		stateCounter--;
	}
	else
	{
		state = 0;
		
		frame = 0;
		frameCounter = 0;
	}
}