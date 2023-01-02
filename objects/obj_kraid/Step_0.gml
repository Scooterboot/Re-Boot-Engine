/// @description 
event_inherited();
if(PauseAI())
{
	exit;
}

var player = noone;
if(instance_exists(obj_Player))
{
	player = obj_Player;
}
else
{
	exit;
}

if(phase == 0) // spawn anim
{
	if(ai[1] == 0)
	{
		var flag = true;
		with(player)
		{
			if(place_meeting(x,y,obj_ClosingHatch))
			{
				flag = false;
			}
		}
		if(flag || ai[0] > 0)
		{
			ai[0]++;
			if(ai[0] > 120)//300)
			{
				ai[0] = 0;
				ai[1] = 1;
			}
		}
	}
	else if(ai[1] == 1)
	{
		global.rmMusic = global.music_Boss1;
		
		if(ai[0] == 0)
		{
			obj_ScreenShaker.Shake(152*2, 2, 2);
		}
		
		if(ai[0] % 5 == 0)
		{
			audio_stop_sound(snd_BlockBreakHeavy);
			audio_play_sound(snd_BlockBreakHeavy,0,false);
		}
		
		if(ai[0] < 152)
		{
			ai[0] += 0.5;
			position.Y -= 0.5;
		}
		else
		{
			ai[0] = 0;
			ai[1] = 0;
			phase = 1;
		}
	}
}
if(phase == 1) // first phase
{
	if(ai[0] == 0) // idle
	{
		
	}
	if(ai[0] == 1) // move and jab
	{
		
	}
	
	if(life <= lifeMax*0.75 && !mouthOpen && headFrame <= 2)
	{
		ai[0] = 0;
		ai[1] = 0;
		ai[2] = 0;
		ai[3] = 0;
		
		phase = 2;
	}
}
if(phase == 2) // phase transition
{
	if(ai[1] == 0)
	{
		ai[0]++;
		if(ai[0] > 60)
		{
			ai[0] = 0;
			ai[1] = 1;
		}
	}
	else if(ai[1] == 1)
	{
		if(ai[0] == 0)
		{
			obj_ScreenShaker.Shake(160*2, 2, 2);
			
			enviroHandler.state = 1;
		}
		
		if(ai[0] % 5 == 0)
		{
			audio_stop_sound(snd_BlockBreakHeavy);
			audio_play_sound(snd_BlockBreakHeavy,0,false);
		}
		
		if(ai[0] < 160)
		{
			ai[0] += 0.5;
			position.Y -= 0.5;
		}
		else
		{
			ai[0] = 0;
			ai[1] = 0;
			phase = 3;
		}
	}
}
if(phase == 3) // second phase
{
	
}
if(phase == 4) // death anim
{
	
}

ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);

ArmIdleAnim(ArmIdleFrame,ArmIdleTransition);

BodyBone.UpdateBone(position,dir,scale);

camPosX = HeadBone.position.X;
camPosY = HeadBone.position.Y;

x = position.X;
y = position.Y;

if(mouthCounter >= 0)
{
	mouthCounter++;
	if(mouthCounter == 60)
	{
		audio_play_sound(snd_Kraid_Roar,0,false);
		mouthOpen = true;
	}
	if(mouthCounter >= 130)
	{
		mouthOpen = false;
		if(headFrame <= 2)
		{
			mouthCounter = -1;
		}
	}
}

if(mouthOpen)
{
	headFrameCounter++;
	if(headFrameCounter > 4)
	{
		headFrame = clamp(headFrame+1,3,6);
		headFrameCounter = 0;
	}
	blinkCounter = 0;
}
else if(headFrame >= 3)
{
	headFrameCounter++;
	if(headFrameCounter > 4)
	{
		headFrame--;
		headFrameCounter = 0;
	}
	blinkCounter = 0;
}
else
{
	blinkCounter++;
	if(blinkCounter > blinkCounterMax)
	{
		if(headFrame > 0)
		{
			headFrameCounter++;
			if(headFrameCounter > 2)
			{
				headFrame--;
				headFrameCounter = 0;
			}
		}
		else
		{
			blinkCounter = 0;
		}
	}
	else if(headFrame < 2)
	{
		headFrameCounter++;
		if(headFrameCounter > 2)
		{
			headFrame++;
			headFrameCounter = 0;
		}
	}
}

eyeGlow = clamp(eyeGlow+0.0375*eyeGlowNum,0,1);
if(eyeGlow >= 1)
{
	eyeGlowNum = -1;
}

if(instance_exists(head))
{
	head.x = HeadBone.position.X;
	head.y = HeadBone.position.Y;

	head.image_angle = (HeadBone.rotation - (45 - 25 * clamp(headFrame-2,0,3))) * dir;
}

if(instance_exists(rHand))
{
	rHand.x = RArmBone[2].position.X;
	rHand.y = RArmBone[2].position.Y;

	rHand.image_angle = RArmBone[2].rotation * dir;

	rHand.image_xscale = lerp(2/3, 1, clamp(rHandFrame-3,0,5) / 5) * dir;
}

if(phase < 4)
{
	var kbody = id,
		khead = head;
	with(player)
	{
		var num = 0;
		while(num < 32 && (place_meeting(x+shiftX,y,kbody) || place_meeting(x+shiftX,y,khead) ||
			(kbody.dir == 1 && x+shiftX < kbody.bbox_left+32) || (kbody.dir == -1 && x+shiftX > kbody.bbox_right-32)))
		{
			shiftX += 1*kbody.dir;
			num++;
		}
	}
}