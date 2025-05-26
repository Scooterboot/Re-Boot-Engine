/// @description 
event_inherited();

if(PauseAI())
{
	exit;
}

var player = obj_Player;
if(instance_exists(player))
{
	var playerX = player.x + player.sprtOffsetX,
		playerY = player.y + player.sprtOffsetY;
	
	var spMoveX = (playerX - x) * moveSpeedMult,
		spMoveY = (playerY - y) * moveSpeedMult;
	var spMaxX = maxSpeed,
		spMaxY = maxSpeed;
	
	//if(point_distance(x,y,playerX,playerY) < 24 || place_meeting(x,y,obj_Player))
	if(collision_rectangle(x-5,y-6,x+5,y+6,obj_Player,false,true))
	{
		spMaxX = maxSpeed * min(abs(x - playerX) / 24, 1);
		spMaxY = maxSpeed * min(abs(y - playerY) / 24, 1);
	}
	
	velX = clamp(velX+spMoveX, -spMaxX, spMaxX);
	velY = clamp(velY+spMoveY, -spMaxY, spMaxY);
}

Collision_Normal(velX,velY,false);

var drainFlag = place_meeting(x,y,obj_Player);
frameCounter++;
if(frameCounter > 6 || (frameCounter > 2 && drainFlag))
{
	frame = scr_wrap(frame+1, 0, 4);
	frameCounter = 0;
}
image_index = frameSeq[frame];
if(drainFlag)
{
	image_index = frameSeq2[frame];
}