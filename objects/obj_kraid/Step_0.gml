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

#region Spawn Anim
if(phase == 0) // spawn anim
{
	if(ai[1] == 0)
	{
		immune = true;
		head.immune = true;
		rHand.immune = true;
		
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
		immune = false;
		head.immune = false;
		rHand.immune = false;
		
		global.rmMusic = global.music_Boss1;
		
		if(ai[0] == 0)
		{
			obj_ScreenShaker.Shake(p1Height*2, 2, 2);
			enviroHandler.state = 1;
			enviroHandler.counter[1] = p1Height*2;
		}
		
		ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);
		
		if(ai[0] < p1Height)
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
#endregion
#region First Phase
if(phase == 1) // first phase
{
	if(ai[0] == 0) // idle
	{
		ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);
		
		ai[1]++;
		if(ai[1] > 240)
		{
			ai[0] = 1;
			ai[1] = 0;
		}
		if(mouthCounter <= -1)
		{
			ai[2]++;
			if(ai[2] > 180)
			{
				ai[0] = 2;
				ai[2] = 0;
			}
		}
	}
	if(ai[0] == 1) // move and jab
	{
		if(ai[1] == 0) // initiate move
		{
			moveDir = 1;
			ai[1] = 1;
		}
		if(ai[1] == 1) // ready pose anim
		{
			if(ArmPokeTransition >= 1 && moveDir == 0)
			{
				ai[1] = 2;
			}
			ArmPokeTransition = min(ArmPokeTransition+0.03,1);
		}
		if(ai[1] == 2) // jab
		{
			if(ArmPokeFrame >= 2)
			{
				ai[1] = 3;
			}
			ArmPokeFrame = min(ArmPokeFrame+0.1,2);
		}
		if(ai[1] >= 3) // recoil and return to idle
		{
			ArmIdleFrame = 0;
			
			if(ai[1] == 3)
			{
				moveDir = -1;
				ai[1] = 4;
			}
			ArmPokeFrame = min(ArmPokeFrame+0.05,4);
			if(ArmPokeFrame >= 3)
			{
				ArmPokeTransition = max(ArmPokeTransition-0.025,0);
			}
			if(ArmPokeTransition <= 0)
			{
				ai[0] = 0;
				ai[1] = irandom(120);
				ArmPokeFrame = 0;
			}
		}
	}
	if(ai[0] == 2)
	{
		ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);
		
		mouthCounter = -1;
		if(ai[2] == 0)
		{
			mouthOpen = true;
			audio_play_sound(snd_Kraid_Roar,0,false);
		}
		
		ai[2]++;
		if(ai[2] % 10 == 0 && headFrame >= 8 && headFrame <= 10)
		{
			var headX = HeadBone.position.X + 10*dir,
				headY = HeadBone.position.Y + 2;
			var rock = instance_create_depth(headX,headY,depth+1,obj_Kraid_Spit);
			rock.velX = random_range(3.5,4)*dir;
			rock.velY = random_range(-1.5,-1);
		}
		if(ai[2] > 90)
		{
			mouthOpen = false;
			ai[0] = 0;
			ai[2] = irandom(120);
		}
	}
	
	if(life <= lifeMax*0.75 && !mouthOpen && headFrame <= 2)
	{
		if(ai[0] == 1 && ai[1] > 1 && moveDir == 0)
		{
			moveDir = -1;
		}
		ai[0] = 0;
		ai[1] = 0;
		ai[2] = 0;
		ai[3] = 0;
		
		phase = 2;
	}
}
else
{
	ArmPokeTransition = max(ArmPokeTransition-0.03,0);
	if(ArmPokeTransition <= 0)
	{
		ArmPokeFrame = 0;
	}
}
#endregion
#region Phase 2 Transition
if(phase == 2) // phase transition
{
	ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);
	
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
			obj_ScreenShaker.Shake(p2Height*2, 2, 2);
			enviroHandler.state = 3;
			enviroHandler.counter[1] = p2Height*2;
		}
		
		if(ai[0] < p2Height)
		{
			ai[0] += 0.5;
			position.Y -= 0.5;
			
			if(moveDir == 0)
			{
				if(position.X < spawnPos.X)
				{
					moveDir = dir;
				}
				if(position.X > spawnPos.X)
				{
					moveDir = -dir;
				}
			}
		}
		else
		{
			ai[0] = 120;
			ai[1] = 0;
			phase = 3;
			
			moveDir = 2*dir;
		}
	}
}
#endregion
#region Second Phase
if(phase == 3) // second phase
{
	if(moveDir == 0)
	{
		if(ai[0] > 0)
		{
			ai[0]--;
		}
		else
		{
			if(irandom(1) == 0)
			{
				moveDir = -1 * irandom_range(1,2);
			}
			else 
			{
				moveDir = 1 * irandom_range(1,2);
			}
			
			if(position.X < p2LeftBound)
			{
				moveDir = abs(moveDir) * dir;
			}
			if(position.X > p2RightBound)
			{
				moveDir = -abs(moveDir) * dir;
			}
			
			ai[0] = irandom_range(60,180);
		}
	}
	
	ai[1]++;
	if(ai[1] > 180)
	{
		var spikePos = new Vector2(BodyBone.position.X+bellySpikePos[ai[2]].X*dir, BodyBone.position.Y+bellySpikePos[ai[2]].Y);
		var spike = instance_create_depth(spikePos.X,spikePos.Y,depth+1,obj_Kraid_BellySpike);
		spike.damage = spikeDamage;
		spike.realLife = id;
		spike.dir = dir;
		spike.image_xscale = dir;
		spike.posType = ai[2];
		
		ai[1] = 0;
		ai[2] = scr_wrap(ai[2]+1,0,3);
	}
	
	ai[3]++;
	if(ai[3] > 150)
	{
		if(ArmFlingFrame < 8)
		{
			ArmFlingTransition = min(ArmFlingTransition+0.05,1);
			if(ArmFlingTransition >= 1)
			{
				ArmIdleFrame = 15;
				if(ArmFlingUseLeft)
				{
					ArmIdleFrame = 7;
				}
				ArmFlingFrame = min(ArmFlingFrame+0.15,8);
				
				if(!fingerFlung && ArmFlingFrame >= 4.5 && ArmFlingFrame <= 4.6)
				{
					var fingX = RArmBone[2].position.X + lengthdir_x(38,RArmBone[2].rotation) * dir,
						fingY = RArmBone[2].position.Y + lengthdir_y(38,RArmBone[2].rotation);
					if(ArmFlingUseLeft)
					{
						fingX = LArmBone[2].position.X + lengthdir_x(38,LArmBone[2].rotation) * dir;
						fingY = LArmBone[2].position.Y + lengthdir_y(38,LArmBone[2].rotation);
					}
					var spX = lengthdir_x(2.5,irandom_range(-45,45)) * dir,
						spY = lengthdir_y(2.5,irandom_range(-45,45));
					var fing = instance_create_depth(fingX,fingY,depth-1,obj_Kraid_FingerProj);
					fing.creator = id;
					fing.damage = fingerDamage;
					fing.velX = spX;
					fing.velY = spY;
					fing.image_xscale = dir;
					fingerFlung = true;
				}
			}
		}
		else
		{
			ArmFlingTransition = max(ArmFlingTransition-0.05,0);
			if(ArmFlingTransition <= 0)
			{
				fingerFlung = false;
				ArmFlingFrame = 0;
				ArmFlingUseLeft = !ArmFlingUseLeft;
				ai[3] = irandom(60);
			}
		}
	}
	else
	{
		ArmIdleFrame = scr_wrap(ArmIdleFrame + 0.1, 0, 16);
	}
}
#endregion
#region Death Anim
if(phase == 4) // death anim
{
	for(var i = 0; i < instance_number(obj_Kraid_FingerProj); i++)
	{
		instance_destroy(instance_find(obj_Kraid_FingerProj,i));
	}
	
	if(ai[0] == 0)
	{
		obj_ScreenShaker.Shake(300, 2, 2);
		enviroHandler.state = 5;
		enviroHandler.counter[1] = 300;
	}
	
	ai[0]++;
	position.Y++;
	
	var animSpeed = 0.4 * ((300-ai[0]) / 300);
	ArmDyingFrame = scr_wrap(ArmDyingFrame + animSpeed, 0, 9);
	ArmDyingTransition = min(ArmDyingTransition+0.1, 1);
	
	var bstep = max(scr_floor(4 + (ai[0]/50)), 5);
	if(ai[0] % bstep == 0 && ai[0] < 300)
	{
		//audio_stop_sound(snd_BlockBreakHeavy);
		//audio_play_sound(snd_BlockBreakHeavy,0,false);
		
		scr_PlayExplodeSnd(0,false);
		var pX = irandom_range(bbox_left-4,bbox_right+4),
			pY = irandom_range(bbox_top-38,bbox_bottom+4);
		part_particles_create(obj_Particles.partSystemA,pX,pY,obj_Particles.npcDeath[choose(0,2)],1);
	}
	
	moveDir = 0;
	
	mouthCounter = -1;
	mouthOpen = false;
	
	if (ai[0] < 3 ||
		(ai[0] >= 40 && ai[0] < 70) ||
		(ai[0] >= 106 && ai[0] < 166) ||
		(ai[0] >= 180))// && ai[0] < 240))
	{
		mouthOpen = true;
	}
	
	if(ai[0] == 40)
	{
		audio_play_sound(snd_Kraid_DyingRoar,0,false);
	}
	
	if(ai[0] > 320)
	{
		instance_destroy();
	}
}
#endregion

#region Move Logic
if(moveDir != 0)
{
	var walkAnimSpd = 0.075;
	
	WalkFrame = scr_wrap(WalkFrame+walkAnimSpd*sign(moveDir),0,8);
	
	//var moveSpd = WalkMoveSpeed[scr_wrap(scr_round(WalkFrame),0,8)] * walkAnimSpd;
	var moveSpd = LerpArray(WalkMoveSpeed,WalkFrame,true) * walkAnimSpd;
	position.X += moveSpd * sign(moveDir) * dir;
	
	WalkFrame2 += walkAnimSpd;
	if(WalkFrame2 >= 4)
	{
		WalkFrame2 = 0;
		moveDir -= sign(moveDir);
		if((position.X < p2LeftBound && moveDir == -dir) || (position.X > p2RightBound && moveDir == dir))
		{
			moveDir = 0;
		}
		position.X = scr_round(position.X);
		
		audio_play_sound(snd_Kraid_Footstep,1,false);
	}
}
#endregion


ArmIdleAnim(ArmIdleFrame,ArmIdleTransition);
ArmPokeAnim(ArmPokeFrame,ArmPokeTransition);
ArmFlingAnim(ArmFlingFrame,ArmFlingTransition);
ArmDyingAnim(ArmDyingFrame,ArmDyingTransition);
WalkAnim(WalkFrame,WalkTransition);

var bodyOffset = 72 - (max(RLegBone[1].position.Y+18,LLegBone[1].position.Y+18) - BodyBone.position.Y);
BodyBone.offsetPosition.Y = min(bodyOffset,0);//min(scr_round(bodyOffset),0);

var basePos = new Vector2(scr_round(position.X),scr_round(position.Y));
BodyBone.UpdateBone(basePos,dir,scale);

camPosX = HeadBone.position.X;
camPosY = HeadBone.position.Y;

x = BodyBone.position.X;
y = BodyBone.position.Y;

if(mouthCounter >= 0)
{
	mouthCounter++;
	if(mouthCounter < 15)
	{
		blinkCounter = blinkCounterMax;
	}
	if(mouthCounter == 15)
	{
		eyeGlowNum = 1;
	}
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
	if(headFrameCounter > 2)//4)
	{
		if(headFrame <= 9)
		{
			headFrame = clamp(headFrame+1,3,9);//6);
		}
		else
		{
			headFrame--;
		}
		headFrameCounter = 0;
	}
	blinkCounter = 0;
}
else if(headFrame >= 3)
{
	headFrameCounter++;
	if(headFrameCounter > 2)//4)
	{
		//headFrame--;
		headFrame++;
		if(headFrame > 14)
		{
			headFrame = 2;
		}
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

	//head.image_angle = (HeadBone.rotation - (45 - 12.5 * clamp(headFrame-2,0,6))) * dir;
	head.image_angle = (HeadBone.rotation - headBoxRotSeq[headFrame]) * dir;
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
		while(num < 32 && (place_meeting(x+shiftX+kbody.dir,y,kbody) || place_meeting(x+shiftX+kbody.dir,y,khead) ||
			(kbody.dir == 1 && x+shiftX < kbody.bbox_left+32) || (kbody.dir == -1 && x+shiftX > kbody.bbox_right-32)))
		{
			shiftX += 1*kbody.dir;
			num++;
		}
	}
}