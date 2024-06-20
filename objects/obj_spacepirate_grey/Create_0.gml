/// @description Initialize
event_inherited();

life = 20;
lifeMax = 20;
damage = 15;
deathType = 2;

dmgMult[DmgType.Explosive][1] = 2; // missile
dmgMult[DmgType.Explosive][2] = 2; // super missile

palIndex = pal_SpacePirate_Grey;

dropChance[0] = 0; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 48; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 0; // power bomb