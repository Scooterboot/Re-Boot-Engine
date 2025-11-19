/// @description Initialize
event_inherited();

life = 90;
lifeMax = 90;
damage = 20;
deathType = 2;

dmgResist[DmgType.Beam][DmgSubType_Beam.Power] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.Missile] = 2;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.Missile] = 2;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.SuperMissile] = 2;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.SuperMissile] = 2;

palIndex = pal_SpacePirate_Green;

dropChance[0] = 18; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 12; // large energy
dropChance[3] = 40; // missile
dropChance[4] = 8; // super missile
dropChance[5] = 4; // power bomb