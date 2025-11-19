/// @description Initialize
event_inherited();

life = 100;
lifeMax = 100;
damage = 90;
dmgResist[DmgType.Misc][DmgSubType_Misc.Grapple] = 10;

dropChance[0] = 2; // nothing
dropChance[1] = 24; // energy
dropChance[2] = 24; // large energy
dropChance[3] = 24; // missile
dropChance[4] = 24; // super missile
dropChance[5] = 4; // power bomb

moveSpeedMult = 1 / 400;
maxSpeed = 3;

frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];
frameSeq2 = [3,4,5,4];

dmgCounterMax = 80;
dmgCounter = dmgCounterMax;

drainSnd = noone;

playerKnockBackDur = 0;
playerInvFrames = 0;

function DamageBoxes()
{
	var _mask = sprite_exists(mask_index) ? mask_index : sprite_index;
	if(dmgBoxMask != noone && sprite_exists(dmgBoxMask))
	{
		_mask = dmgBoxMask;
	}
	
	if(!instance_exists(dmgBoxes[0]))
	{
		dmgBoxes[0] = self.CreateDamageBox(0,0,_mask,hostile);
	}
	else if(hostile && damage > 0 && !frozen && !dead)
	{
	    var player = collision_rectangle(x-5,y-6,x+5,y+6,obj_Player,false,true);
	    if(instance_exists(player))
	    {
			if(dmgCounter <= 0)
			{
				dmgBoxes[0].Damage(x,y,damage,damageType,damageSubType);
				
				dmgCounter = dmgCounterMax;
			}
			else
			{
				dmgCounter = max(dmgCounter-1,0);
			}
			
			if(!audio_is_playing(snd_HealthDrainLoop) && !audio_is_playing(drainSnd))
			{
				drainSnd = audio_play_sound(snd_HealthDrainLoop,0,true);
			}
	    }
		else
		{
			audio_stop_sound(drainSnd);
			dmgCounter = min(dmgCounter+0.1,dmgCounterMax);
		}
	}
	else
	{
		audio_stop_sound(drainSnd);
	}
}

function OnXCollision(fVX, isOOB = false)
{
	velX = 0;
}
function OnYCollision(fVY, isOOB = false)
{
	velY = 0;
}