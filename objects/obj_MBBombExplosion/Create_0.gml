/// @description Initialize

event_inherited();

isBomb = true;
multiHit = true;

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[0],1);

damageType = DmgType.Explosive;
damageSubType[3] = true;
damageSubType[5] = true;