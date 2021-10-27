/// @description Animate
if(frame < 4)
{
    frameCounter += 1;
    if(frameCounter > 1)
    {
        frame += 1;
        frameCounter = 0;
    }
}
else
{
    instance_destroy();
}