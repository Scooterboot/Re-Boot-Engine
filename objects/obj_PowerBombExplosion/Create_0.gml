/// @description Initialize
event_inherited();
image_speed = 0;
scaleTimer = 0;
scaleMult = 0.05;
scale = scaleMult*scaleTimer;
image_xscale = scale;
image_yscale = scale;
pAlpha = 1;
alpha2 = 1;
image_alpha = pAlpha*alpha2;

doorOpenType[DoorOpenType.Bomb] = true;
doorOpenType[DoorOpenType.PBomb] = true;
blockBreakType[BlockBreakType.Bomb] = true;
blockBreakType[BlockBreakType.PBomb] = true;
blockBreakType[BlockBreakType.Chain] = true;

multiHit = true;

//switchLOSCheck = false;

type = ProjType.Bomb;

damageSubType[3] = true;
damageSubType[4] = true;
damageSubType[5] = true;

distort = instance_create_depth(x,y,depth-1,obj_Distort);