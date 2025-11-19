/// @description Initialize
event_inherited();
life = 15;
lifeMax = 15;
damage = 5;
dmgResist[DmgType.Misc][DmgSubType_Misc.Grapple] = 1;

dropChance[0] = 0; // nothing
dropChance[1] = 22; // energy
dropChance[2] = 10; // large energy
dropChance[3] = 68; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 0; // power bomb

mSpeed = 0.5;

image_speed = 0.3;

dmgBoxMask = mask_NPC_CrawlerHitBox;
lifeBoxMask = mask_NPC_CrawlerHitBox;