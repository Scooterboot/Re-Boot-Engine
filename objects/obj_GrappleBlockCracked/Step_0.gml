/// @description Crumble Logic

if(crumble)
{
	canBeCulled = false;
    if(time >= timeLeft)
    {
        instance_destroy();
    }
    time += 1;
}
