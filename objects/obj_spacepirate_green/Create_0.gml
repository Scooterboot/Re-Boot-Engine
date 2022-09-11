/// @description Initialize
event_inherited();

life = 90;
lifeMax = 90;
damage = 20;
deathType = 2;

dmgMult[DmgType.Beam][1] = 0; // power beam
dmgMult[DmgType.Explosive][1] = 2; // missile
dmgMult[DmgType.Explosive][2] = 2; // super missile

palIndex = pal_SpacePirate_Green;