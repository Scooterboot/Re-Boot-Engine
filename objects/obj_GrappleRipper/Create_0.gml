/// @description Initialize
event_inherited();

life = 200;
lifeMax = 200;
damage = 10;

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
//dmgResist[DmgType.Misc][DmgSubType_Misc.SpeedBoost] = 0;
//dmgResist[DmgType.Misc][DmgSubType_Misc.ScrewAttack] = 0;

dropChance[0] = 0; // nothing
dropChance[1] = 0; // energy
dropChance[2] = 1; // large energy
dropChance[3] = 0; // missile
dropChance[4] = 254; // super missile
dropChance[5] = 0; // power bomb

mSpeed2 = 1;
mSpeed = mSpeed2;

dirFrame = 5*dir;
frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];

jetFlameSprt = sprt_GrappleRipper_Flame;
jetFrame = 0;
jetFrameCounter = 0;
jetFrame2 = 0;
jetFrameSeq = [0,1,2,1];

function PauseAI()
{
	return (global.GamePaused() || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}