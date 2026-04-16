direction = 0;
speed = 0;

if(global.GamePaused())
{
    exit;
}

SetControlVars("player");

var player = creator;
if(!instance_exists(player))
{
	instance_destroy();
	exit;
}

var pPos = self.GetPlayerPos();

if(grappleState == GrappleState.None)
{
	var distMax = player.grappleMaxDist,
		grapSpeed = lerp(28,8, grappleDist/distMax);
	if(!grapReel)
	{
		grappleDist = min(grappleDist+grapSpeed, distMax);
		if(grappleDist >= distMax || !cFire)
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
	
	for(var i = 0; i < point_distance(pPos.X,pPos.Y, x+fVelX,y+fVelY); i++)
	{
		var ang = point_direction(pPos.X,pPos.Y, x+fVelX,y+fVelY);
		var xx = pPos.X+lengthdir_x(i,ang),
			yy = pPos.Y+lengthdir_y(i,ang);
		var xoff = lengthdir_x(4,ang), yoff = lengthdir_y(4,ang);
		var gNum = 0;
		if(global.grappleAimAssist) // if targeting reticle is enabled, use more precise grapple point detection
		{
			gNum = collision_line_list(xx,yy, xx-xoff,yy-yoff, ColType_GrapplePoint, true,true,blockList,true);
		}
		else // otherwise, use a generous hitbox as an alternative to aim assist
		{
			var x1 = min(xx, xx-4*sign(xoff)),
				y1 = min(yy, yy-4*sign(yoff)),
				x2 = max(xx, xx-4*sign(xoff)),
				y2 = max(yy, yy-4*sign(yoff));
			gNum = collision_rectangle_list(x1,y1,x2,y2, ColType_GrapplePoint, true,true,blockList,true);
		}
		
		if(gNum > 0)
		{
			for(var j = 0; j < gNum; j++)
			{
				var block = blockList[| j];
				if(instance_exists(block))
				{
					grapBlock = block;
					x = xx;
					y = yy;
					break;
				}
			}
			ds_list_clear(blockList);
		}
		
		if(instance_exists(grapBlock))
		{
			break;
		}
	}
	
	if(instance_exists(grapBlock))
	{
		audio_play_sound(snd_GrappleBeam_Latch,0,false);
		if(grapBlock.object_index == obj_PushBlock || object_is_ancestor(grapBlock.object_index,obj_PushBlock))
		{
			grappleState = GrappleState.PushBlock;
		}
		else
		{
			if(object_is_ancestor(grapBlock.object_index,obj_Tile))
			{
				grapBlockPosX = scr_floor(clamp(x+sign(fVelX)*4,grapBlock.bbox_left,grapBlock.bbox_right-1)/16)*16 + 8;
				grapBlockPosY = scr_floor(clamp(y+sign(fVelY)*4,grapBlock.bbox_top,grapBlock.bbox_bottom-1)/16)*16 + 8;
			}
		    grappleState = GrappleState.Swing;
		}
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
			
			self.TileInteract(x+_signX,y+_signY);
			impacted = 1;
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
			
			self.TileInteract(x+_signX,y+_signY);
			impacted = 1;
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
if(grappleState != GrappleState.None)
{
	for(var i = 0; i < array_length(dmgBoxes); i++)
	{
		instance_destroy(dmgBoxes[i]);
	}
	
	if(instance_exists(grapBlock))
	{
		if(grapBlockPosX > -1)
		{
			x = grapBlockPosX;
		}
		else
		{
			x = scr_round(grapBlock.bbox_left + (grapBlock.bbox_right-1-grapBlock.bbox_left)/2);
		}
		
		if(grapBlockPosY > -1)
		{
			y = grapBlockPosY;
		}
		else
		{
			y = scr_round(grapBlock.bbox_top + (grapBlock.bbox_bottom-1-grapBlock.bbox_top)/2);
		}
		
	    drawGrapEffect = true;
		if(grappleState == GrappleState.Swing)
		{
		    if(!stateChanged && player.state != State.Grapple)
		    {
		        if(player.animState == AnimState.Grip)
		        {
		            player.dir *= -1;
		            player.dirFrame = 4*dir;
		        }
		        player.grappleDist = point_distance(player.position.X, player.position.Y, x, y);
		        player.grapAngle = point_direction(player.position.X, player.position.Y, x, y) - 90;
				player.ChangeState(State.Grapple, AnimState.Grapple, MoveState.Custom, mask_Player_Somersault, false, true);
				stateChanged = true;
		    }
			if(grapBlock.object_index == obj_GrappleBlockCracked)
		    {
		        grapBlock.crumble = true;
		    }
		}
		if(grappleState == GrappleState.PushBlock)
		{
			if(player.state != State.Grapple && player.state != State.Stand && player.state != State.Crouch)
			{
				if(!stateChanged)
				{
					if(player.animState == AnimState.Grip)
			        {
			            player.dir *= -1;
			            player.dirFrame = 4*dir;
			        }
			        player.grappleDist = point_distance(player.position.X, player.position.Y, x, y);
			        player.grapAngle = point_direction(player.position.X, player.position.Y, x, y) - 90;
					if(player.state != State.Morph)
					{
						player.ChangeState(State.Grapple, AnimState.Grapple, MoveState.Custom, mask_Player_Somersault, false, true);
					}
					grappleState = GrappleState.Swing;
					stateChanged = true;
				}
			}
			else if(player.grappleDist <= 0)
			{
				player.grappleDist = point_distance(player.x, player.y, x, y);
			}
			else if(point_distance(player.x, player.y, x, y) > player.grappleDist+48)
			{
				instance_destroy();
				exit;
			}
		}
		
	    if(!audio_is_playing(snd_GrappleBeam_Loop) && !audio_is_playing(snd_GrappleBeam_Shoot))
	    {
	        audio_play_sound(snd_GrappleBeam_Loop,0,true);
	    }
        
	    part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gTrail,1);
		
		layer = layer_get_id("Projectiles_fg");
		
		if(!cFire && (player.state != State.Grapple || player.grapWJCounter <= 0))
		{
			if(player.state == State.Grapple)
			{
				player.shotDelayTime = 8;//14;
			}
			instance_destroy();
		}
	}
	else
	{
	    instance_destroy();
	}
}

position.X = x;
position.Y = y;

SetReleaseVars("player");
