/// @description Initialize
event_inherited();

blockDestroyType = 1;
doorOpenType = 0;

multiHit = true;

type = ProjType.Bomb;

damageSubType[3] = true;
damageSubType[5] = true;

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[0],1);