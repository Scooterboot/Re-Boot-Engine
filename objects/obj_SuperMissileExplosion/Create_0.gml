event_inherited();

blockDestroyType = 3;
doorOpenType = 2;

multiHit = true;

damageSubType[1] = true;
damageSubType[2] = true;
damageSubType[5] = true;

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[2],1);

var dist = instance_create_depth(0,0,0,obj_Distort);
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