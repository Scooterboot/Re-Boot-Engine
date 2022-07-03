event_inherited();

//isMissile = true;
//isSuperMissile = true;
type = ProjType.Missile;
multiHit = true;

part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[2],1);

damageType = 2;
damageSubType[1] = true;
damageSubType[2] = true;