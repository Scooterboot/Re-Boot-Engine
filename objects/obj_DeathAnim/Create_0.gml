posX = x-camera_get_view_x(view_camera[0]);
posY = y-camera_get_view_x(view_camera[0]);
dir = 1;

screenFade[0] = 0;
screenFade[1] = 0;
screenFade[2] = 0;

animSequence = array(0,1,2,0,1,2,0,1,2,0,1,2,4,5,5,6,6,7,7,6,6,5,5,4,4,3,3,8,9,10,11,12,13,14,15,16,17);
frame = 0;
frameCounter = 0;

//audio_play_sound(snd_Death,0,false);
soundPlayed = false;

global.rmMusic = noone;