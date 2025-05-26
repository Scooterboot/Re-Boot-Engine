/// @description Initialize
event_inherited();
image_speed = 0;

life = 60;
lifeMax = 60;
damage = 20;

dropChance[0] = 40; // nothing
dropChance[1] = 8; // energy
dropChance[2] = 16; // large energy
dropChance[3] = 34; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 2; // power bomb

deathOffsetY = -13*gravDir;