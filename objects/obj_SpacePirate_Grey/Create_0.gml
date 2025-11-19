/// @description Initialize
event_inherited();

life = 20;
lifeMax = 20;
damage = 15;
deathType = 2;

dmgResist[DmgType.Explosive][DmgSubType_Explosive.Missile] = 2;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.Missile] = 2;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.SuperMissile] = 2;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.SuperMissile] = 2;

palIndex = pal_SpacePirate_Grey;

dropChance[0] = 0; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 48; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 0; // power bomb