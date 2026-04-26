/// @description Chain Logic

if(destroy)
{
    if(time >= timeLeft)
    {
        instance_destroy();
    }
    time += 1;
}
