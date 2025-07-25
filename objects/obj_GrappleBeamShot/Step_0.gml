direction = 0;
speed = 0;

if(global.gamePaused)
{
    exit;
}

var player = creator;
if(!instance_exists(player))
{
	instance_destroy();
	exit;
}

var angDif = angle_difference(player.shootDir,shootDir);
if(angDif != 0)
{
	shootDir += min(abs(angDif), 15) * sign(angDif);
}

var distMax = player.grappleMaxDist;
grapSpeedMax = lerp(28,8, grappleDist/distMax);

grapSignX = lengthdir_x(1,shootDir);
grapSignY = lengthdir_y(1,shootDir);

if(grappleState != GrappleState.None)
{
    if(instance_exists(grapBlock))
    {
		grappled = true;
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
	            if(player.stateFrame == State.Grip)
	            {
	                player.dir *= -1;
	                player.dirFrame = 4*dir;
	            }
	            player.grappleDist = point_distance(player.position.X, player.position.Y, x, y);
	            player.grapAngle = point_direction(player.position.X, player.position.Y, x, y) - 90;
				player.ChangeState(State.Grapple,State.Grapple,mask_Player_Somersault,false,true);
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
				if(player.state == State.Morph)
				{
					instance_destroy();
					exit;
				}
				else if(!stateChanged)
				{
					if(player.stateFrame == State.Grip)
		            {
		                player.dir *= -1;
		                player.dirFrame = 4*dir;
		            }
		            player.grappleDist = point_distance(player.position.X, player.position.Y, x, y);
		            player.grapAngle = point_direction(player.position.X, player.position.Y, x, y) - 90;
		            player.ChangeState(State.Grapple,State.Grapple,mask_Player_Somersault,false,true);
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
    }
    else
    {
        instance_destroy();
		exit;
    }
}
else
{
	if(impacted < 2)
	{
		var gPoint = noone;
		
		if(impacted == 1)
		{
			grappleDist = max(grappleDist - grapSpeedMax, 0);
			x = player.shootPosX+lengthdir_x(grappleDist,shootDir);
		    y = player.shootPosY+lengthdir_y(grappleDist,shootDir);
			if(grappleDist <= 0)
			{
				impacted = 2;
			}
		}
		else
		{
			grapSpeed = grapSpeedMax;
			while(grapSpeed > 0 && !entity_collision_line(xprevious-grapSignX,yprevious-grapSignY,x+grapSignX,y+grapSignY))
		    {
		        grappleDist += 1;
				x = player.shootPosX+lengthdir_x(grappleDist,shootDir);
				y = player.shootPosY+lengthdir_y(grappleDist,shootDir);
		        grapSpeed -= 1;
		    }
			
			var impactFlag = false;
			
			var num = collision_line_list(xprevious-grapSignX,yprevious-grapSignY,x+grapSignX,y+grapSignY,solids,true,true,gp_list,true);
			for(var i = 0; i < num; i++)
			{
				if(instance_exists(gp_list[| i]))
				{
					impactFlag = true;
					
					var col = gp_list[| i];
					
					if(col.object_index == obj_MovingTile || object_is_ancestor(col.object_index,obj_MovingTile))
					{
						impactFlag = col.grappleCollision;
					}
					
					if(object_is_in_array(col.object_index, ColType_GrapplePoint))
					{
						gPoint = col;
						impactFlag = false;
						break;
					}
				}
			}
			ds_list_clear(gp_list);
			
			if(impactFlag)
			{
				TileInteract(x+grapSignX,y+grapSignY);
				OnImpact(x,y);
				impacted = 1;
			}
			else if(point_distance(player.x, player.y, x, y) > player.grappleMaxDist-(grapSpeedMax/2))
		    {
		        impacted = 1;
		    }
		}
		
		for(var i = 0; i < point_distance(player.shootPosX,player.shootPosY,x,y); i++)
		{
			if(!instance_exists(gPoint))
			{
				var ang = shootDir;
				var xx = player.shootPosX+lengthdir_x(i,ang),
					yy = player.shootPosY+lengthdir_y(i,ang);
				var xoff = lengthdir_x(4,ang), yoff = lengthdir_y(4,ang);
				var gp = 0;
				if(global.grappleAimAssist) // if targeting reticle is enabled, use more precise grapple point detection
				{
					gp = collision_line_list(xx,yy,xx-xoff,yy-yoff,ColType_GrapplePoint,true,true,gp_list,true);
				}
				else // otherwise, use a generous hitbox as an alternative to aim assist
				{
					var x1 = min(xx, xx-4*sign(xoff)),
						y1 = min(yy, yy-4*sign(yoff)),
						x2 = max(xx, xx-4*sign(xoff)),
						y2 = max(yy, yy-4*sign(yoff));
					gp = collision_rectangle_list(x1,y1,x2,y2,ColType_GrapplePoint,true,true,gp_list,true);
				}
				if(gp > 0)
				{
					for(var j = 0; j < gp; j++)
					{
						var point = gp_list[| j];
						if(instance_exists(point))
						{
							gPoint = point;
							x = xx;
							y = yy;
							break;
						}
					}
				}
				ds_list_clear(gp_list);
			}
			else
			{
				break;
			}
		}
		
	    if(instance_exists(gPoint))
	    {
	        audio_play_sound(snd_GrappleBeam_Latch,0,false);
	        grapBlock = gPoint;
			if(grapBlock.object_index == obj_PushBlock || object_is_ancestor(grapBlock.object_index,obj_PushBlock))
			{
				grappleState = GrappleState.PushBlock;
				//player.grappleDist = point_distance(player.x, player.y, x, y);
			}
			else
			{
				if(object_is_ancestor(grapBlock.object_index,obj_Tile))
				{
					grapBlockPosX = scr_floor(clamp(x+grapSignX*4,grapBlock.bbox_left,grapBlock.bbox_right-1)/16)*16 + 8;
					grapBlockPosY = scr_floor(clamp(y+grapSignY*4,grapBlock.bbox_top,grapBlock.bbox_bottom-1)/16)*16 + 8;
				}
		        grappleState = GrappleState.Swing;
			}
	    }
		
		if(damage > 0)
		{
			for(var j = 0; j < point_distance(player.position.X,player.position.Y, x,y); j += 8)
			{
				var _dir = point_direction(player.position.X,player.position.Y, x,y),
					xw = x-lengthdir_x(j,_dir),
					yw = y-lengthdir_y(j,_dir);
				scr_DamageNPC(xw,yw,damage,damageType,damageSubType,0,-1,10);
			}
		}
	}
	else
	{
		instance_destroy();
		exit;
	}
}