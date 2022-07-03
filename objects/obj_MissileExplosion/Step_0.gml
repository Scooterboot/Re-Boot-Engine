scr_OpenDoor(x,y,1);
scr_BreakBlock(x,y,2);

scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,10);

instance_destroy();