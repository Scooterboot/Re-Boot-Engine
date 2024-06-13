/// @description 
event_inherited();

if(PauseAI())
{
	exit;
}

frameCounter++;
var flag = (frameCounter > 2);
var seq = frameSeq;
if(state == 2)
{
	flag = (frameCounter > 1 || frame == 1 || frame == 3);
	seq = frameSeq2;
}

if(flag)
{
	frame = scr_wrap(frame+1,0,4);
	frameCounter = 0;
}
image_index = seq[frame];