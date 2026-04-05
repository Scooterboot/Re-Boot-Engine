/// @description Chain Logic
event_inherited();

if(destroy)
{
    if(time >= timeLeft)
    {
        instance_destroy();
    }
    time += 1;
}