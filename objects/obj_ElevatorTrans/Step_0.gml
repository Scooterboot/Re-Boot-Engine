/// @description Transition Logic
audio_stop_sound(snd_PowerBombExplode);
audio_stop_sound(snd_GrappleBeam_Loop);
if(room != goal)
{
	if(alpha >= 1)
	{
	    room_goto(goal);
	}
	alpha = min(alpha + 0.05,1);
}
else
{
	if(alpha <= 0)
	{
	    global.roomTrans = false;
	    global.gamePaused = false;
	    instance_destroy();
	}
	if(nextEle == noone)
	{
	    for(var i = 0; i < instance_number(obj_Elevator); i += 1)
	    {
	        if(instance_find(obj_Elevator,i).elevatorID == targetID)
	        {
	            nextEle = instance_find(obj_Elevator,i);
	            nextEle.activeDir = activeDir;
				nextEle.incoming = true;
	            var playerHeight = (obj_Player.bbox_bottom-obj_Player.bbox_top);
	            if(activeDir == 1)
	            {
	                nextEle.y = -(playerHeight + 8);
	            }
	            else
	            {
	                nextEle.y = room_height + playerHeight + 8;
	            }
	        }
	    }
	}
	
	if(nextEle != noone)
	{
	    if(!transitionComplete)
		{
			obj_Camera.x = clamp(nextEle.x-global.resWidth/2,0,room_width-global.resWidth);
			obj_Camera.y = clamp(nextEle.y-global.resHeight/2,0,room_height-global.resHeight);
			var xDiff = scr_round(obj_Camera.x-obj_Camera.playerX),
				yDiff = scr_round(obj_Camera.y-obj_Camera.playerY);
			camera_set_view_pos(view_camera[0], scr_round(obj_Camera.playerX)+xDiff, scr_round(obj_Camera.playerY)+yDiff);
			
		    obj_Player.position.X = nextEle.x;
		    obj_Player.position.Y = nextEle.y - (obj_Player.bbox_bottom-obj_Player.y);
			with(obj_Player)
	        {
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
			
		    transTimer++;
			if(transTimer > 2)
			{
				transitionComplete = true;
			}
		}
		
		if(fadeCounter < 20)
		{
		    fadeCounter++;
		}
		else if(transitionComplete)
		{
		    alpha = max(alpha - 0.05, 0);
		}
	}
}