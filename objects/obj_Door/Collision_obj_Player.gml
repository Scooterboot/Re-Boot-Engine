if(!global.roomTrans)
{
    global.gamePaused = true;
    if(!entered)
    {
        scr_Transition(nextroom,doorID,nextDoorID,obj_Player.x - x,obj_Player.y - y,spawnDist);
        entered = true;
    }
}