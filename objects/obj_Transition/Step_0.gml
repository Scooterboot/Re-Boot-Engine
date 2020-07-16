audio_stop_sound(snd_PowerBombExplode);
if(room != goal)
{
    var door = noone;
    for(var i = 0; i < instance_number(obj_Door); i += 1)
    {
        if(instance_find(obj_Door,i).doorID == currentID)
        {
            door = instance_find(obj_Door,i);
        }
    }
    if(door != noone)
    {
        angle = door.image_angle;

        samusX = obj_Player.x - camera_get_view_x(view_camera[0]);
        samusY = obj_Player.y - camera_get_view_y(view_camera[0]);

        transSprtDraw = true;
        screenPosX = (obj_Camera.x+(global.resWidth/2)) - door.x;
        screenPosY = (obj_Camera.y+(global.resHeight/2)) - door.y;
    }
    if(alpha >= 1)
    {
        /*with(obj_GrappleBeamShot)
        {
            instance_destroy();
        }
        obj_Player.grapple = obj_GrappleBeamShot;*/

        room_goto(goal);
    }
    alpha = min(alpha + 0.075,1);
}
else
{
    if(alpha <= 0)
    {
        global.roomTrans = false;
        global.gamePaused = false;
        instance_destroy();
    }
    if(nextDoor != noone)
    {
		if(!transitionComplete)
		{
			obj_Camera.x = clamp(nextDoor.x + screenPosX + lengthdir_x(global.resWidth/2, nextDoor.image_angle) - (global.resWidth/2), 0, room_width-global.resWidth);
			obj_Camera.y = clamp(nextDoor.y + screenPosY + lengthdir_y(global.resHeight/2, nextDoor.image_angle) - (global.resHeight/2), 0, room_height-global.resHeight);
		}
        obj_Player.x = nextDoor.x + difX + lengthdir_x(spawnDist, nextDoor.image_angle) + lengthdir_x(obj_Player.bbox_right - obj_Player.bbox_left, nextDoor.image_angle);
        obj_Player.y = nextDoor.y + difY + lengthdir_y(spawnDist, nextDoor.image_angle) + lengthdir_y(obj_Player.bbox_bottom - obj_Player.bbox_top, nextDoor.image_angle);
        with(obj_Player)
        {
            var gNum = 16;
            while(grounded && !place_collide(0,1) && place_collide(0,3+max(ceil(abs(velX)),1)) && gNum > 0)
            {
                y += 1;
                gNum -= 1;
            }
        }
        
        //with(obj_Camera)
        //{
            /*playerX = obj_Player.x;
			var ysp = obj_Player.y - obj_Player.yprevious;
			if(((obj_Player.state == State.Stand || obj_Player.state == State.Crouch) && obj_Player.prevState != obj_Player.state)
				|| (obj_Player.state == State.Morph && obj_Player.prevState == State.Stand))
			{
				ysp = 0;
			}
			var fysp = ysp;
			if(playerY < obj_Player.y)
			{
				fysp = min(ysp+1,obj_Player.y-playerY);
			}
			if(playerY > obj_Player.y)
			{
				fysp = max(ysp-1,obj_Player.y-playerY);
			}
			playerY += fysp;
			playerY = clamp(playerY,obj_Player.y-11,obj_Player.y+11);
			
			x = clamp(x,0,room_width-global.resWidth);
			y = clamp(y,0,room_height-global.resHeight);
			var xDiff = scr_round(x-playerX),
				yDiff = scr_round(y-playerY);
			camera_set_view_pos(view_camera[0], scr_round(playerX)+xDiff, scr_round(playerY)+yDiff);*/
			//event_perform(ev_step,0);
        //}
        
        if(nextDoor.hatch != noone)
        {
            nextDoor.hatch.frame = 4;
        }
        //nDoorX = nextDoor.x - camera_get_view_x(view_camera[0]);
        //nDoorY = nextDoor.y - camera_get_view_y(view_camera[0]);
        nSamusX = obj_Player.x - camera_get_view_x(view_camera[0]);
        nSamusY = obj_Player.y - camera_get_view_y(view_camera[0]);
        angle = nextDoor.image_angle;
        if(samusX != nSamusX || samusY != nSamusY)
        {
            samusSpeedX = min(samusSpeedX+1.5,max(abs(nSamusX - samusX)*0.15,0.5));
            if(samusX < nSamusX)
            {
                samusX = min(samusX + samusSpeedX, nSamusX);
            }
            else
            {
                samusX = max(samusX - samusSpeedX, nSamusX);
            }
            
            samusSpeedY = min(samusSpeedY+1.5,max(abs(samusY - nSamusY)*0.15,0.5));
            if(samusY < nSamusY)
            {
                samusY = min(samusY + samusSpeedY, nSamusY);
            }
            else
            {
                samusY = max(samusY - samusSpeedY, nSamusY);
            }
        }
        else
        {
            alpha = max(alpha - 0.075, 0);
        }
        transitionComplete = true;
    }
    else if(room == goal)
    {
        for(i = 0; i < instance_number(obj_Door); i += 1)
        {
            if(instance_find(obj_Door,i).doorID == targetID)
            {
                nextDoor = instance_find(obj_Door,i);
            }
        }
    }
}