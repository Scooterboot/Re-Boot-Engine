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

var distMax = player.grappleMaxDist;
grapSpeedMax = lerp(28,8, grappleDist/distMax);

grapSignX = lengthdir_x(1,player.shootDir);
grapSignY = lengthdir_y(1,player.shootDir);

if(grappleState != GrappleState.None)
{
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
	        if(player.state != State.Grapple)
	        {
	            if(player.stateFrame == State.Grip)
	            {
	                player.dir *= -1;
	                player.dirFrame = 4*dir;
	            }
	            player.grappleDist = point_distance(player.x, player.y, x, y);
	            player.grapAngle = point_direction(player.x, player.y, x, y) - 90;
	            player.state = State.Grapple;
	            player.stateFrame = State.Grapple;
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
				else
				{
					if(player.stateFrame == State.Grip)
		            {
		                player.dir *= -1;
		                player.dirFrame = 4*dir;
		            }
		            player.grappleDist = point_distance(player.x, player.y, x, y);
		            player.grapAngle = point_direction(player.x, player.y, x, y) - 90;
		            player.state = State.Grapple;
		            player.stateFrame = State.Grapple;
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
        
        //part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.PartBeam[3],1);
        //part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.PartBeam[2],1);
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
			x = player.shootPosX+lengthdir_x(grappleDist,player.shootDir);
		    y = player.shootPosY+lengthdir_y(grappleDist,player.shootDir);
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
				x = player.shootPosX+lengthdir_x(grappleDist,player.shootDir);
				y = player.shootPosY+lengthdir_y(grappleDist,player.shootDir);
		        grapSpeed -= 1;
		    }
			
			var impactFlag = false;
			
			var num = collision_line_list(xprevious-grapSignX,yprevious-grapSignY,x+grapSignX,y+grapSignY,all,true,true,gp_list,true);
			for(var i = 0; i < num; i++)
			{
				if(instance_exists(gp_list[| i]) && asset_has_any_tag(gp_list[| i].object_index,solids,asset_object))
				{
					impactFlag = true;
					
					var col = gp_list[| i];
					
					if(col.object_index == obj_MovingTile || object_is_ancestor(col.object_index,obj_MovingTile))
					{
						impactFlag = col.grappleCollision;
					}
					
					if(asset_has_any_tag(col.object_index,"IGrapplePoint",asset_object))
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
				var ang = player.shootDir;
				var xx = player.shootPosX+lengthdir_x(i,ang),
					yy = player.shootPosY+lengthdir_y(i,ang);
				var gp = collision_rectangle_list(xx-4,yy-4,xx+4,yy+4,all,true,true,gp_list,true);
				for(var j = 0; j < gp; j++)
				{
					var point = gp_list[| j];
					if(instance_exists(point) && asset_has_any_tag(point.object_index, "IGrapplePoint", asset_object))
					{
						gPoint = point;
						x = xx;
						y = yy;
						break;
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
					grapBlockPosX = scr_floor(clamp(x,grapBlock.bbox_left,grapBlock.bbox_right-1)/16)*16 + 8;
					grapBlockPosY = scr_floor(clamp(y,grapBlock.bbox_top,grapBlock.bbox_bottom-1)/16)*16 + 8;
				}
		        grappleState = GrappleState.Swing;
			}
	    }
	}
	else
	{
		instance_destroy();
		exit;
	}
}

if(damage > 0)
{
	//scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,4);
	
	for(var j = 0; j < grappleDist; j += 8)
	{
		var xw = x-lengthdir_x(j,player.shootDir),
			yw = y-lengthdir_y(j,player.shootDir);
		scr_DamageNPC(xw,yw,damage,damageType,damageSubType,0,-1,10);
	}
}