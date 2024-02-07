audio_stop_sound(snd_PowerBombExplode);
audio_stop_sound(snd_GrappleBeam_Loop);
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

        playerX = obj_Player.position.X - camera_get_view_x(view_camera[0]);
        playerY = obj_Player.position.Y - camera_get_view_y(view_camera[0]);
		if(obj_Player.state == State.Stand && obj_Player.stateFrame == State.Stand)
		{
			obj_Player.stateFrame = State.Run;
		}

        transSprtDraw = true;
        screenPosX = (obj_Camera.x+(global.resWidth/2)) - door.x;
        screenPosY = (obj_Camera.y+(global.resHeight/2)) - door.y;
    }
    if(alpha >= 1)
    {
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
	if(nextDoor == noone)
    {
        for(var i = 0; i < instance_number(obj_Door); i += 1)
        {
            if(instance_find(obj_Door,i).doorID == targetID)
            {
                nextDoor = instance_find(obj_Door,i);
            }
        }
    }
	
    if(nextDoor != noone)
    {
		if(!transitionComplete)
		{
			obj_Camera.x = nextDoor.x + screenPosX + lengthdir_x(global.resWidth/2, nextDoor.image_angle) - (global.resWidth/2);
			obj_Camera.y = nextDoor.y + screenPosY + lengthdir_y(global.resHeight/2, nextDoor.image_angle) - (global.resHeight/2);
			obj_Camera.x = clamp(obj_Camera.x,0,room_width-global.resWidth);
			obj_Camera.y = clamp(obj_Camera.y,0,room_height-global.resHeight);
			var xDiff = scr_round(obj_Camera.x-obj_Camera.playerX),
				yDiff = scr_round(obj_Camera.y-obj_Camera.playerY);
			camera_set_view_pos(view_camera[0], scr_round(obj_Camera.playerX)+xDiff, scr_round(obj_Camera.playerY)+yDiff);
		}
        obj_Player.position.X = nextDoor.x + difX + lengthdir_x(spawnDist, nextDoor.image_angle) + lengthdir_x(obj_Player.bbox_right - obj_Player.bbox_left, nextDoor.image_angle);
        obj_Player.position.Y = nextDoor.y + difY + lengthdir_y(spawnDist, nextDoor.image_angle) + lengthdir_y(obj_Player.bbox_bottom - obj_Player.bbox_top, nextDoor.image_angle);
        with(obj_Player)
        {
            var gNum = 16;
            while(grounded && !entity_place_collide(0,1) && entity_place_collide(0,3+max(ceil(abs(velX)),1)) && gNum > 0)
            {
                y += 1;
                gNum -= 1;
            }
			
			array_fill(mbTrailPosX, noone);
			array_fill(mbTrailPosY, noone);
			array_fill(mbTrailDir, noone);
			
			x = scr_round(position.X);
			y = scr_round(position.Y);
			
			liquid = liquid_place();
			liquidPrev = liquid;
			liquidTop = liquid_top();
			liquidTopPrev = liquidTop;
			
			prevTop = bbox_top;
			prevBottom = bbox_bottom;
        }
        
        if(instance_exists(nextDoor.hatch))
        {
            nextDoor.hatch.frame = 4;
        }
        var nPlayerX = obj_Player.position.X - camera_get_view_x(view_camera[0]),
			nPlayerY = obj_Player.position.Y - camera_get_view_y(view_camera[0]);
        angle = nextDoor.image_angle;
        if(playerX != nPlayerX || playerY != nPlayerY)
        {
            playerSpeedX = min(playerSpeedX+1.5,max(abs(nPlayerX - playerX)*0.15,0.5));
            if(playerX < nPlayerX)
            {
                playerX = min(playerX + playerSpeedX, nPlayerX);
            }
            else
            {
                playerX = max(playerX - playerSpeedX, nPlayerX);
            }
            
            playerSpeedY = min(playerSpeedY+1.5,max(abs(playerY - nPlayerY)*0.15,0.5));
            if(playerY < nPlayerY)
            {
                playerY = min(playerY + playerSpeedY, nPlayerY);
            }
            else
            {
                playerY = max(playerY - playerSpeedY, nPlayerY);
            }
        }
        else
        {
            alpha = max(alpha - 0.075, 0);
        }
        transitionComplete = true;
    }
}