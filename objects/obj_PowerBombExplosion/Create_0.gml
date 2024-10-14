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

blockDestroyType = 4;
doorOpenType = 3;

multiHit = true;

//switchCollide = false;

type = ProjType.Bomb;

damageSubType[3] = true;
damageSubType[4] = true;
damageSubType[5] = true;

distort = instance_create_depth(x,y,depth-1,obj_Distort);