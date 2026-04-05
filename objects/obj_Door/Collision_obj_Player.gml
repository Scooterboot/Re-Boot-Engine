if(global.pauseState != PauseState.RoomTrans && nextRoom != -1 && doorID != -1 && nextDoorID != -1)
{
    if(!entered)
    {
        scr_Transition(nextRoom,doorID,nextDoorID,obj_Player.position.X - x,obj_Player.position.Y - y,spawnDist);
        entered = true;
    }
}