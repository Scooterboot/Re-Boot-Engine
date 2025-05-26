/// @description Crumble Logic
event_inherited();

if(crumble)
{
    if(time >= timeLeft)
    {
        instance_destroy();
    }
    time += 1;
}