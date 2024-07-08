if(!global.roomTrans && nextroom != -1 && doorID != -1 && nextDoorID != -1)
{
    global.gamePaused = true;
    if(!entered)
    {
        scr_Transition(nextroom,doorID,nextDoorID,obj_Player.x - x,obj_Player.y - y,spawnDist);
        entered = true;
    }
}