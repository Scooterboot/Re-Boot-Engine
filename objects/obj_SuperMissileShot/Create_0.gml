/// @description Initialize
event_inherited();
image_speed = 0;
particleDelay = 4;
impactSnd = -1;
//isMissile = true;
//isSuperMissile = true;
type = ProjType.Missile;

damageType = DmgType.Explosive;
damageSubType[1] = true;
damageSubType[2] = true;

blockDestroyType = -1;//3;
doorOpenType = -1;//2;
depth -= 1;