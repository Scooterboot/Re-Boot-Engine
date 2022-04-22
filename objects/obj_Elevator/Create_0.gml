/// @description Initialize
event_inherited();
image_speed = 0;
image_index = 0;

frame1 = 0;
frame1Sequence = array(5,5,4,4,0,0,6,6,0,0,4,4);
frame2 = 0;
frame2Counter = 0;

dir = 0;

nextroom = noone;
elevatorID = -1;
nextElevatorID = -1;

activeDir = 0;

PosY = y;

resetState = false;