/// @description 
event_inherited();
if(PauseAI())
{
	exit;
}

if(sign(dirFrame) == dir)
{
	mSpeed = mSpeed2;
}
else
{
	mSpeed = 0;
}

frameCounter += 1;
if(frameCounter > 7)
{
    frame = scr_wrap(frame+1,0,image_number);
    frameCounter = 0;
}

image_index = frameSeq[frame];

dirFrame = clamp(dirFrame+dir,-5,5);
if(dirFrame == 0)
{
    dirFrame = dir;
}

if(abs(dirFrame) < 5)
{
    image_index = 3;
}

image_xscale = sign(dirFrame);