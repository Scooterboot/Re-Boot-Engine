/// @description Initialize
event_inherited();

image_speed = 0.25;
bombTimer = 55;//60;
//exploded = false;

velX = 0;
velY = 0;
spreadType = -1;
spreadSpeed = 0;
spreadDir = 0;
spreadFrict = 4;

forceJump = false;

type = ProjType.Bomb;

damageSubType[3] = true;

exploProj = obj_MBBombExplosion;
exploDmgMult = 1;