/// @description 
event_inherited();

life = 800;
lifeMax = 800;
damage = 0;

dmgResist[DmgType.Beam][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Charge][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.All] = 0;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.All] = 0;
dmgResist[DmgType.Misc][DmgSubType_Misc.All] = 0;

freezeImmune = true;
createPlatformOnFrozen = false;
dmgAbsorb = true;

dropChance[0] = 2; // nothing
dropChance[1] = 32; // energy
dropChance[2] = 32; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 2; // power bomb

enum WorkRobotState
{
	Idle,
	Moving,
	FastMoving
}
state = WorkRobotState.Idle;
ai = [0,0,0];

facingDir = sign(image_xscale);
image_xscale = 1;
image_yscale = 1;
movingDir = facingDir;

mSpeed = 0.2;

moveXSeq = [1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1];
movedAtFrame = -1;

idleFrame = 0;
walkFrame = 0;

currentSprt = sprt_WorkRobot_Idle;
currentFrame = 0;

eyePalIndex = 0;
eyePalNum = 0;

grounded = true;
grav[0] = 0.5;
grav[1] = 0.25;
fallSpeedMax = 7;

sndPlayedAt = 0;

dirChangeFrame = [11,10,9,8,7,6,5,4,3,2,1,0,23,22,21,20,19,18,17,16,15,14,13,12];
function ChangeFacingDir(newDir)
{
	if(sign(newDir) != 0 && sign(newDir) != facingDir)
	{
		if(state == WorkRobotState.Idle)
		{
			idleFrame = (idleFrame == 1) ? 0 : 1;
		}
		if(state == WorkRobotState.Moving || state == WorkRobotState.FastMoving)
		{
			//walkFrame = scr_wrap(walkFrame+6*newDir,0,24);
			walkFrame = dirChangeFrame[scr_floor(walkFrame)] + frac(walkFrame);
			currentFrame = scr_floor(walkFrame);
		}
		facingDir = newDir;
	}
}
function TryChangeToIdleState()
{
	if(state == WorkRobotState.Moving || state == WorkRobotState.FastMoving)
	{
		if (currentFrame <= 2 || 
			(currentFrame >= 5 && currentFrame <= 7) || 
			(currentFrame >= 10 && currentFrame <= 14) ||
			(currentFrame >= 17 && currentFrame <= 19) ||
			currentFrame >= 22)
		{
			idleFrame = (currentFrame <= 12) ? 1 : 0;
			
			state = WorkRobotState.Idle;
			//currentSprt = sprt_WorkRobot_Idle;
			//currentFrame = idleFrame;
		}
	}
}

wallCol = 0;
function OnXCollision(fVX, isOOB = false)
{
	wallCol = sign(fVX);
	velX = 0;
	fVelX = 0;
}
function OnYCollision(fVY, isOOB = false)
{
	velY = 0;
	fVelY = 0;
}

topOffsetX = [0,-1,-2,-4,-7,-2, 0, 2, 7, 4, 2, 1];
function GetTopXOffset(_frame = walkFrame, _fOff = -0.5)
{
	if(state == WorkRobotState.Moving || state == WorkRobotState.FastMoving)
	{
		return scr_round(LerpArray(topOffsetX, max(_frame+_fOff ,0), true) * facingDir);
	}
	return 0;
}

for(var i = 0; i < 2; i++)
{
	var type = (i > 0) ? obj_WorkRobot_MSolid2 : obj_WorkRobot_MSolid1;
	
	mBlocks[i] = instance_create_layer(x,y,layer_get_id("Collision"),type);
	mBlocks[i].ignoredEntity = id;
	mBlocks[i].canGrip = false;
	mBlockOffset[i] = new Vector2();
}

dmgBoxes = array_create(2, noone);
function DamageBoxes()
{
	var xdiff = self.GetTopXOffset();
	for(var i = 0; i < 2; i++)
	{
		var _mask = (i > 0) ? mask_WorkRobot_MSolid2 : mask_WorkRobot_MSolid1;
		
		if(!instance_exists(dmgBoxes[i]))
		{
			dmgBoxes[i] = self.CreateDamageBox(0, 0, _mask, hostile);
		}
		else
		{
			if(i == 0)
			{
				dmgBoxes[i].offsetX = xdiff;
			}
			if(sign(xdiff) != 0)
			{
				dmgBoxes[i].image_xscale = sign(xdiff);
			}
			dmgBoxes[i].mask_index = _mask;
			dmgBoxes[i].Damage(x,y,damage,damageType,damageSubType);
		}
	}
}
lifeBoxes = array_create(2, noone);
function LifeBoxes()
{
	var xdiff = self.GetTopXOffset();
	for(var i = 0; i < 2; i++)
	{
		var _mask = (i > 0) ? mask_WorkRobot_MSolid2 : mask_WorkRobot_MSolid1;
		
		if(!instance_exists(lifeBoxes[i]))
		{
			lifeBoxes[i] = self.CreateLifeBox(0, 0, _mask, hostile);
		}
		else
		{
			if(i == 0)
			{
				lifeBoxes[i].offsetX = xdiff;
			}
			if(sign(xdiff) != 0)
			{
				lifeBoxes[i].image_xscale = sign(xdiff);
			}
			lifeBoxes[i].mask_index = _mask;
			lifeBoxes[i].UpdatePos(x,y);
		}
	}
}


function OnDamageAbsorbed(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType)
{
	
}
