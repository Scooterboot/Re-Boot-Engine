/// @description Anim
if(dethType == 1)
{
    if(timer == (scr_round(timer/5)*5))
    {
        scr_PlayExplodeSnd(0,false);
    }
    
    if(timer == (scr_round(timer/3)*3))
    {
        part_particles_create(obj_Particles.partSystemA,x+random_range(-width/2,width/2),y+random_range(-height/2,height/2),obj_Particles.npcDeath[choose(0,1)],1);
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
        for(var i = 2; i < 6; i++)
        {
            part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.npcDeath[i],1);
        }
    }
    
    if(timer == 9)
    {
        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.npcDeath[6],random_range(4,7));
    }

    timer++;
    if(timer >= 12)
    {
        instance_destroy();
    }
}