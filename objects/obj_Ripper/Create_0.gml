/// @description Initialize
event_inherited();

life = 200;
lifeMax = 200;
damage = 5;

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

dropChance[0] = 26; // nothing
dropChance[1] = 32; // energy
dropChance[2] = 8; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 2; // power bomb

mSpeed2 = 1;
mSpeed = mSpeed2;

dirFrame = 5*dir;
frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];