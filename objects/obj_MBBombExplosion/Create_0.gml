/// @description Initialize
event_inherited();

doorOpenType[DoorOpenType.Bomb] = true;
blockBreakType[BlockBreakType.Bomb] = true;
blockBreakType[BlockBreakType.Chain] = true;

multiHit = true;

type = ProjType.Bomb;

damageType = DmgType.ExplSplash;
damageSubType[DmgSubType_Explosive.Bomb] = true;

explode = 0;
self.DamageBoxes();

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[0],1);

var dist = instance_create_depth(0,0,depth-1,obj_Distort);
dist.left = x-17;
dist.right = x+17;
dist.top = y-17;
dist.bottom = y+17;
dist.alpha = 0;
dist.alphaNum = 1;
dist.alphaRate = 0.15;
dist.alphaRateMultDecr = 3;
dist.colorMult = 0.25;
dist.spread = 0.625;