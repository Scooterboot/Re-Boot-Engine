/// @description Initialize
event_inherited();

life = 200;
lifeMax = 200;
damage = 5;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][1] = 0; // missile
dmgMult[DmgType.Explosive][2] = 1; // super missile
dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 1; // power bomb
dmgMult[DmgType.Misc][5] = 0; // boost ball

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