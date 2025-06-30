/// @description Initialize
event_inherited();
image_speed = 0;
image_index = 0;

frame1 = 0;
frame1Sequence = [5,5,4,4,0,0,6,6,0,0,4,4];
frame2 = 0;
frame2Counter = 0;

//dir = 0;

//nextroom = noone;
//elevatorID = -1;
//nextElevatorID = -1;

upward = false;
up_nextRoom = noone;
up_nextElevatorID = -1;

downward = false;
down_nextRoom = noone;
down_nextElevatorID = -1;

elevatorID = -1;

activeDir = 0;
incoming = false;
singleRoom = false;

resetState = false;