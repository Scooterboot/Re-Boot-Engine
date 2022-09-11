/// @description 
event_inherited();
if(global.gamePaused)
{
	exit;
}

frameCounter++;
frame = frameSeq[min(frameCounter,array_length(frameSeq)-1)];
if(frameCounter >= array_length(frameSeq))
{
	instance_destroy();
}