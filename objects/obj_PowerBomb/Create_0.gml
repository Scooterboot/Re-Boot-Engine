/// @description Initialize
event_inherited();

image_speed = 0.1875;
bombTimer = 70;

forceJump = false;

type = ProjType.Bomb;

damageSubType[3] = true;
damageSubType[4] = true;

exploProj = obj_PowerBombExplosion;
exploDmgMult = 1;
exploSnd = snd_PowerBombExplode;

ignoreCamera = true;

function MovePushBlock() {}