/// @description 

image_speed = 0;
image_index = 0;

back = instance_create_layer(x,y,"NPCs_bg",obj_MorphLauncher_Back);

state = 0;
stateCounter = 0;

frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];
frameSeq2 = [0,1,2,3,4,3,2,1];
frameFinal = 0;

lFrameSeq = [2,3,4,5,6,5,4,3];
lFrameFinal = 0;