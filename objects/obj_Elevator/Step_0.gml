/// @description Logic
/*if(!global.gamePaused)
{
    image_speed = 0.5;
}
else
{
    image_speed = 0;
    exit;
}*/
if(global.gamePaused)
{
    exit;
}

var eleSpeed = 3;

if(activeDir != 0)
{
    if(obj_Player.position.X > x)
    {
        obj_Player.position.X = max(obj_Player.position.X-3,x);
    }
    if(obj_Player.position.X < x)
    {
        obj_Player.position.X = min(obj_Player.position.X+3,x);
    }
    if(activeDir == dir)
    {
        y += eleSpeed*activeDir;
        if((activeDir == 1 && obj_Player.bbox_top > room_height+8) || (activeDir == -1 && obj_Player.bbox_bottom < -8))
        {
            scr_ElevatorTrans(nextroom,elevatorID,nextElevatorID,activeDir);
        }
    }
    else
    {
        if(activeDir == 1)
        {
            y = min(y+eleSpeed,ystart);
        }
        if(activeDir == -1)
        {
            y = max(y-eleSpeed,ystart);
        }
        if(y == ystart)
        {
            activeDir = 0;
            resetState = true;
        }
    }
    obj_Player.position.Y = y - (obj_Player.bbox_bottom-obj_Player.y);
	
	obj_Player.x = scr_round(obj_Player.position.X);
	obj_Player.y = scr_round(obj_Player.position.Y);

    frame2Counter++;
    if(frame2Counter > 1)
    {
        frame2++;
        frame2Counter = 0;
    }
    if(frame2 > 6)
    {
        frame2 = 0;
    }
    image_index = frame2;

    if(!audio_is_playing(snd_Elevator))
    {
        audio_play_sound(snd_Elevator,0,true);
    }
}
else
{
    if(resetState)
    {
        obj_Player.state = State.Stand;
        resetState = false;
    }

    frame1++;
    if(frame1 > 11)
    {
        frame1 = 0;
    }
    image_index = frame1Sequence[frame1];

    audio_stop_sound(snd_Elevator);
}