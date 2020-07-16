/// @description Code
event_inherited();
if(!global.gamePaused)
{
    velocity = min(velocity * 1.1, 15.75);
    if(particleDelay <= 0)
    {
        part_particles_create(obj_Particles.partSystemC,x-lengthdir_x(12,direction),y-lengthdir_y(12,direction),obj_Particles.mTrail[1],1);
        particleDelay = 5 / (1 + (velocity-(8/3))*0.25);
    }
    particleDelay = max(particleDelay - 1, 0);
}