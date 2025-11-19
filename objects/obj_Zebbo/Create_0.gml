/// @description 
event_inherited();

life = 30;
lifeMax = 30;
damage = 20;
dmgResist[DmgType.Misc][DmgSubType_Misc.Grapple] = 1;

dropChance[0] = 0; // nothing
dropChance[1] = 0; // energy
dropChance[2] = 56; // large energy
dropChance[3] = 4; // missile
dropChance[4] = 40; // super missile
dropChance[5] = 2; // power bomb

image_speed = 0;
frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];
frameSeq2 = [3,4,5,4];