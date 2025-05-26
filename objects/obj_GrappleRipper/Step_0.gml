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
    frame = scr_wrap(frame+1,0,4);
    frameCounter = 0;
}
image_index = frameSeq[frame];

jetFrameCounter += 1;
if(jetFrameCounter > 3)
{
	jetFrame2 = scr_wrap(jetFrame2+1,0,4);
	jetFrameCounter = 0;
}
jetFrame = jetFrameSeq[jetFrame2];

dirFrame = clamp(dirFrame+dir,-5,5);
if(dirFrame == 0)
{
    dirFrame = dir;
}

if(abs(dirFrame) < 5)
{
    image_index = 3;
	jetFlameSprt = noone;
}
else
{
	jetFlameSprt = sprt_GrappleRipper_Flame;
}

image_xscale = sign(dirFrame);