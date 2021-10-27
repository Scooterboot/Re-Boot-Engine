/// @description Chain Logic
event_inherited();

if(destroy)
{
    if(time >= 3)
    {
        instance_destroy();
    }
    time += 1;
}