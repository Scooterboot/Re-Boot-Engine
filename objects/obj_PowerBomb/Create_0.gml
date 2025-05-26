/// @description Initialize
event_inherited();

image_speed = 0.1875;
bombTimer = 70;

forceJump = false;

type = ProjType.Bomb;

damageSubType[3] = true;
damageSubType[4] = true;

doorOpenType[DoorOpenType.Bomb] = true;
doorOpenType[DoorOpenType.PBomb] = true;
blockBreakType[BlockBreakType.Bomb] = true;
blockBreakType[BlockBreakType.PBomb] = true;
blockBreakType[BlockBreakType.Chain] = true;

exploProj = obj_PowerBombExplosion;
exploDmgMult = 1;
exploSnd = snd_PowerBombExplode;

ignoreCamera = true;

function MovePushBlock() {}
function TileInteract(_x,_y) {}