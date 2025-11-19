/// @description Initialize
event_inherited();

life = 20;
lifeMax = 20;
damage = 0;

dmgResist[DmgType.Beam][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Charge][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.Missile] = 0;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.Missile] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.SuperMissile] = 1;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.SuperMissile] = 1;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.Bomb] = 0;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.Bomb] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.PowerBomb] = 1;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.PowerBomb] = 1;
dmgResist[DmgType.Misc][DmgSubType_Misc.BoostBall] = 0;
dmgResist[DmgType.Misc][DmgSubType_Misc.SpeedBoost] = 0;
dmgResist[DmgType.Misc][DmgSubType_Misc.ScrewAttack] = 0;

dropChance[0] = 2; // nothing
dropChance[1] = 32; // energy
dropChance[2] = 32; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 2; // power bomb

dir = sign(image_xscale);
mSpeed = 1;

gravCounter = 0;
gravCounterMax = 20;
grav = 0.03;//0.07;
fallSpeedMax = 4;

lift = 0.05;//0.11;
liftSpeedMax = 4;

yStart = y;

frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];

deathOffsetX = 0;
deathOffsetY = 8;

function OnXCollision(fVX, isOOB = false)
{
	dir = -sign(fVX);
	velX = 0;
	fVelX = 0;
}