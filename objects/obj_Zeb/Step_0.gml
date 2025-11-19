/// @description 
event_inherited();

if(self.PauseAI())
{
	exit;
}

var fCount = 1;
if(state == 2)
{
	fCount = 0;
}

frameCounter++;
if(frameCounter > fCount)
{
	frame = scr_wrap(frame+1,0,6);
	frameCounter = 0;
}
image_index = frameSeq[frame];