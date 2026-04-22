direction = 0;
speed = 0;

if(global.GamePaused())
{
    exit;
}

var player = creator;
if(!instance_exists(player))
{
	instance_destroy();
	exit;
}

var pPos = self.GetPlayerPos();

if(gravState == GravGrapState.None)
{
	var distMax = player.gravGrapMaxDist,
		grapSpeed = lerp(28,8, grappleDist/distMax);
	if(!grapReel)
	{
		grappleDist = min(grappleDist+grapSpeed, distMax);
		if(grappleDist >= distMax || !global.control[INPUT_VERB.Fire])
		{
			grapReel = true;
		}
	}
	else
	{
		grappleDist = max(grappleDist-grapSpeed, 0);
		if(grappleDist <= 0)
		{
			impacted = 2;
		}
	}
	
	var _destX = player.shootPosX+lengthdir_x(grappleDist,player.shootDir),
		_destY = player.shootPosY+lengthdir_y(grappleDist,player.shootDir);
	var _destDir = point_direction(x,y, _destX,_destY),
		_destLen = point_distance(x,y, _destX,_destY);
	var _destSpd = min(max(_destLen/4, 28), _destLen);
	velX = lengthdir_x(_destSpd, _destDir);
	velY = lengthdir_y(_destSpd, _destDir);
	
	speed_x = player.position.X - player.oldPosition.X;
	speed_y = player.position.Y - player.oldPosition.Y;
	fVelX = velX + speed_x;
	fVelY = velY + speed_y;
	
	// grap object logic
	
	if(instance_exists(grapObject))
	{
		audio_play_sound(snd_GrappleBeam_Latch,0,false);
		gravState = GravGrapState.Object;
	}
	else if(impacted <= 0)
	{
		if(self.entity_collision_line(x,y, x+fVelX,y+fVelY))
		{
			var velocity = point_distance(0,0,fVelX,fVelY);
			var _dir = point_direction(0,0,fVelX,fVelY);
			var _signX = lengthdir_x(1,_dir),
				_signY = lengthdir_y(1,_dir);
			
			while(!self.entity_collision_line(x,y, x+_signX,y+_signY) && velocity >= 0)
			{
				x += _signX;
				y += _signY;
				velocity--;
			}
			
			//self.TileInteract(x+_signX,y+_signY);
			//impacted = 1;
			audio_play_sound(snd_GrappleBeam_Latch,0,false);
			gravState = GravGrapState.Ground;
			
			grapBlock = self.GetGrapBlock(collision_line_list(x,y, x+_signX,y+_signY, solids, true,true,gBlockList,true));
			if(instance_exists(grapBlock))
			{
				grapBlockOffX = x - grapBlock.x;
				grapBlockOffY = y - grapBlock.y;
			}
		}
		else if(self.entity_collision_line(x,y, pPos.X,pPos.Y))
		{
			var velocity = point_distance(x,y, pPos.X,pPos.Y);
			var _dir = point_direction(x,y, pPos.X,pPos.Y);
			var _signX = lengthdir_x(1,_dir),
				_signY = lengthdir_y(1,_dir);
			
			while(!self.entity_collision_line(x,y, x+_signX,y+_signY) && velocity >= 0)
			{
				x += _signX;
				y += _signY;
				velocity--;
			}
			
			//self.TileInteract(x+_signX,y+_signY);
			//impacted = 1;
			audio_play_sound(snd_GrappleBeam_Latch,0,false);
			gravState = GravGrapState.Ground;
			
			grapBlock = self.GetGrapBlock(collision_line_list(x,y, x+_signX,y+_signY, solids, true,true,gBlockList,true));
			if(instance_exists(grapBlock))
			{
				grapBlockOffX = x - grapBlock.x;
				grapBlockOffY = y - grapBlock.y;
			}
		}
		else
		{
			x += fVelX;
			y += fVelY;
		}
		if(x < 0 || x > room_width || y < 0 || y > room_height)
		{
			x = clamp(x,0,room_width);
			y = clamp(y,0,room_height);
			
			impacted = 1;
		}
	}
}
if(gravState != GravGrapState.None)
{
	grappled = true;
	if(gravState == GravGrapState.Object)
	{
		if(instance_exists(grapObject))
		{
			
		}
		else
		{
			impacted = 2;
		}
	}
	if(gravState == GravGrapState.Ground)
	{
		if(!stateChanged && player.state != State.GravGrapple)
		{
			player.gravGrapDist = point_distance(player.position.X, player.position.Y, x, y);
			player.gravGrapAngle = player.shootDir - 90;
			player.ChangeState(State.GravGrapple, AnimState.GravGrapple, MoveState.Custom, mask_Player_Somersault, false, true);
			stateChanged = true;
		}
		
		if(instance_exists(grapBlock))
		{
			x = grapBlock.x + grapBlockOffX;
			y = grapBlock.y + grapBlockOffY;
		}
		else
		{
			impacted = 2;
		}
	}
	
	if(!audio_is_playing(snd_GrappleBeam_Loop) && !audio_is_playing(snd_GrappleBeam_Shoot))
	{
	    audio_play_sound(snd_GrappleBeam_Loop,0,true);
	}
	
	if(!global.control[INPUT_VERB.Fire])
	{
		impacted = 2;
	}
}

position.X = x;
position.Y = y;
