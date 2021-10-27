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
    if(obj_Player.x > x)
    {
        obj_Player.x = max(obj_Player.x-3,x);
    }
    if(obj_Player.x < x)
    {
        obj_Player.x = min(obj_Player.x+3,x);
    }
    if(activeDir == dir)
    {
        PosY += eleSpeed*activeDir;
        if((activeDir == 1 && obj_Player.bbox_top > room_height+8) || (activeDir == -1 && obj_Player.bbox_bottom < -8))
        {
            scr_ElevatorTrans(nextroom,elevatorID,nextElevatorID,activeDir);
        }
    }
    else
    {
        if(activeDir == 1)
        {
            PosY = min(PosY+eleSpeed,y);
        }
        if(activeDir == -1)
        {
            PosY = max(PosY-eleSpeed,y);
        }
        if(PosY == y)
        {
            activeDir = 0;
            resetState = true;
        }
    }
    obj_Player.y = PosY - (obj_Player.bbox_bottom-obj_Player.y);

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