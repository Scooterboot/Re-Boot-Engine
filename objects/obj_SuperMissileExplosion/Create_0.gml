event_inherited();

doorOpenType[DoorOpenType.Missile] = true;
doorOpenType[DoorOpenType.SMissile] = true;
blockBreakType[BlockBreakType.Missile] = true;
blockBreakType[BlockBreakType.SMissile] = true;

multiHit = true;

damageSubType[2] = true;
damageSubType[5] = true;

explode = 0;

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[2],1);

var dist = instance_create_depth(0,0,depth-1,obj_Distort);
dist.left = x-36;
dist.right = x+36;
dist.top = y-36;
dist.bottom = y+36;
dist.alpha = 0;
dist.alphaNum = 1;
dist.alphaRate = 0.1;
dist.alphaRateMultDecr = 3;
dist.colorMult = 0.75;
dist.spread = 0.625;