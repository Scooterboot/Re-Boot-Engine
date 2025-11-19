/// @description 
event_inherited();

if(self.PauseAI())
{
	exit;
}

frameCounter++;
var seq = frameSeq;
if(state == 3)
{
	seq = frameSeq2;
}

if(frameCounter > 1)
{
	frame = scr_wrap(frame+1,0,8);
	frameCounter = 0;
}
image_index = seq[frame];