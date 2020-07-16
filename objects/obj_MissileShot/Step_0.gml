/// @description Trail
event_inherited();
if(!global.gamePaused)
{
    particleDelay = max(particleDelay - 1, 0);
    if(particleDelay <= 0)
    {
        part_particles_create(obj_Particles.partSystemC,x-lengthdir_x(velocity,direction),y-lengthdir_y(velocity,direction),obj_Particles.mTrail[0],1);
        particleDelay = 3;
    }
}