if(!global.roomTrans && nextroom != -1 && doorID != -1 && nextDoorID != -1)
{
    global.gamePaused = true;
    if(!entered)
    {
        scr_Transition(nextroom,doorID,nextDoorID,obj_Player.position.X - x,obj_Player.position.Y - y,spawnDist);
        entered = true;
    }
}