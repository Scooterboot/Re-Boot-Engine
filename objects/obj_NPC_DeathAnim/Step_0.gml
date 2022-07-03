/// @description Anim
if(dethType == 1)
{
    //if(timer == (scr_round(timer/5)*5))
	if(timer%8 == 0)
    {
        scr_PlayExplodeSnd(0,false);
    }
    
    //if(timer == (scr_round(timer/3)*3))
	if(timer%5 == 0)
    {
        //part_particles_create(obj_Particles.partSystemA,x+random_range(-width/2,width/2),y+random_range(-height/2,height/2),obj_Particles.npcDeath[choose(0,1)],1);
        part_particles_create(obj_Particles.partSystemA,irandom_range(bbox_left-4,bbox_right+4),irandom_range(bbox_top-4,bbox_bottom+4),obj_Particles.npcDeath[choose(0,2)],1);
    }
    
    if(timer > 40)
    {
        instance_destroy();
    }
    
    timer++;
}
if(dethType == 2)
{
    visible = true;
    image_index = 2 + scr_round(timer/3);

    if(timer == 2)
    {
        for(var i = 3; i < 7; i++)
        {
            part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.npcDeath[i],1);
        }
    }
    
    if(timer == 9)
    {
        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.npcDeath[7],random_range(4,7));
    }

    timer++;
    if(timer >= 12)
    {
        instance_destroy();
    }
}