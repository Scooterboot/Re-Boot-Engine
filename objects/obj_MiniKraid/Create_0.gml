/// @description Initialize
event_inherited();

life = 400;
lifeMax = 400;

damage = 100;

deathType = 2;

freezeImmune = true;

// In vanilla SM, these are set to 2, but imo that makes it feel very weak
dmgResist[DmgType.Explosive][DmgSubType_Explosive.Missile] = 1;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.Missile] = 1;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.SuperMissile] = 1;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.SuperMissile] = 1;

dropChance[0] = 0; // nothing
dropChance[1] = 10; // energy
dropChance[2] = 30; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 40; // super missile
dropChance[5] = 2; // power bomb

dir = image_xscale;
image_xscale = 1;
image_yscale = 1;

moveDir = dir;
prevMoveDir = 0;
moveCounter = 0;
moveCounter2 = 0;
moveSpeed = 0.5;

spikeFire[0] = irandom(10);
spikeFire[1] = irandom(10)+10;
spikeFire[2] = irandom(10);
spikeFireMax = 120;

spikePosX[0] = 8;
spikePosY[0] = 0;
spikePosX[1] = 14;
spikePosY[1] = 13;
spikePosX[2] = 8;
spikePosY[2] = 24;

spitCounter = 0;
spitFired = false;

moveYOffset = [0,0,1,2,2,2,1,0,0,0,1,2,2,2,1,0];
walkFrame = 0;
walkFrameCounter = 0;
mouthFrame = 0;
mouthFrameCounter = 0;
mouthFrameNum = -1;
handFrame = 0;
handFrameCounter = 0;

tailFrame = 0;
tailFrameCounter = 0;
tailFrameSequence = [1,2,3,2];
tailFrame2 = 0;


function PauseAI()
{
	return (global.GamePaused() || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

function NPCDropItem(_x,_y)
{
	for(var i = 0; i < 5; i++)
	{
		self._NPCDropItem(_x+irandom_range(-12,12),_y+irandom_range(-12,12));
	}
}

boxMask = [mask_MiniKraid_Head, mask_MiniKraid_UpperBody, mask_MiniKraid_LowerBody];
dmgBoxes = array_create(array_length(boxMask),noone);
lifeBoxes = array_create(array_length(boxMask),noone);

function DamageBoxes()
{
	for(var i = 0; i < array_length(boxMask); i++)
	{
		var _mask = boxMask[i];
		if(!instance_exists(dmgBoxes[i]))
		{
			dmgBoxes[i] = self.CreateDamageBox(0,0,_mask,hostile);
		}
		else
		{
			dmgBoxes[i].mask_index = _mask;
			dmgBoxes[i].image_xscale = dir;
			dmgBoxes[i].image_yscale = 1;
			dmgBoxes[i].Damage(x,y+sprtOffsetY,damage,damageType,damageSubType);
		}
	}
}
function LifeBoxes()
{
	for(var i = 0; i < array_length(boxMask); i++)
	{
		var _mask = boxMask[i];
		if(!instance_exists(lifeBoxes[i]))
		{
			lifeBoxes[i] = self.CreateLifeBox(0,0,_mask,hostile);
		}
		else
		{
			lifeBoxes[i].mask_index = _mask;
			lifeBoxes[i].image_xscale = dir;
			lifeBoxes[i].image_yscale = 1;
			lifeBoxes[i].UpdatePos(x,y+sprtOffsetY);
		}
	}
}