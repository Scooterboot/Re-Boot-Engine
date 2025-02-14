event_inherited();

doorOpenType[DoorOpenType.Missile] = true;
blockBreakType[BlockBreakType.Missile] = true;

multiHit = true;

damageSubType[1] = true;
damageSubType[5] = true;

explode = 0;

//image_xscale = 0.6;
//image_yscale = 0.6;
part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[1],1);

var dist = instance_create_depth(0,0,depth-1,obj_Distort);
dist.left = x-18;
dist.right = x+18;
dist.top = y-18;
dist.bottom = y+18;
dist.alpha = 0;
dist.alphaNum = 1;
dist.alphaRate = 0.125;
dist.alphaRateMultDecr = 2.5;
dist.colorMult = 0.5;
dist.spread = 0.625;