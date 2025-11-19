/// @description Initialize
event_inherited();

life = 15;
lifeMax = 15;
damage = 10;
dmgResist[DmgType.Misc][DmgSubType_Misc.Grapple] = 1;

dropChance[0] = 137; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 3; // large energy
dropChance[3] = 85; // missile
dropChance[4] = 5; // super missile
dropChance[5] = 5; // power bomb

frame = 0;
frameCounter = 0;

diveSoundPlayed = false;
digSoundPlayed = false;

deathOffsetY = 12;