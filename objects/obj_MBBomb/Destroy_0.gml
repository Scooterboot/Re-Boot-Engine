event_inherited();
scr_PlayExplodeSnd(0,false);
var bomb = instance_create_layer(x,y,"Projectiles_fg",obj_MBBombExplosion);
bomb.damage = damage;
bomb.damageType = damageType;