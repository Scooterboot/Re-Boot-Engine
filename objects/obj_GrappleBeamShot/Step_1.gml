direction = 0;
speed = 0;

if(global.gamePaused)
{
    exit;
}

var dist = point_distance(obj_Player.x, obj_Player.y, x, y),
	maxDist = obj_Player.grappleMaxDist;
grapSpeedMax = lerp(28,12,dist/maxDist);

grapSpeed = grapSpeedMax;
grapSignX = lengthdir_x(1,obj_Player.shootDir);
grapSignY = lengthdir_y(1,obj_Player.shootDir);

if(grappled)
{
    if(instance_exists(grapBlock))
    {
        if(grapBlockPosX >= 0)
		{
			x = grapBlockPosX;
		}
		else
		{
			x = grapBlock.bbox_left + abs(grapBlock.bbox_right-grapBlock.bbox_left)/2;
		}
		if(grapBlockPosY >= 0)
		{
			y = grapBlockPosY;
		}
		else
		{
			y = grapBlock.bbox_top + abs(grapBlock.bbox_bottom-grapBlock.bbox_top)/2;
		}
        drawGrapEffect = true;
        if(obj_Player.state != State.Grapple)
        {
            if(obj_Player.stateFrame == State.Grip)
            {
                obj_Player.dir *= -1;
                obj_Player.dirFrame = 4*dir;
            }
            obj_Player.grappleDist = point_distance(obj_Player.x, obj_Player.y, x, y);
            obj_Player.grapAngle = point_direction(obj_Player.x, obj_Player.y, x, y) - 90;
            obj_Player.state = State.Grapple;
            obj_Player.stateFrame = State.Grapple;
        }
        if(!audio_is_playing(snd_GrappleBeam_Loop) && !audio_is_playing(snd_GrappleBeam_Latch) && !audio_is_playing(snd_GrappleBeam_Shoot))
        {
            audio_play_sound(snd_GrappleBeam_Loop,0,true);
        }
        if(grapBlock.object_index == obj_GrappleBlockCracked)
        {
            grapBlock.crumble = true;
        }
        //part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.PartBeam[3],1);
        //part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.PartBeam[2],1);
        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gTrail,1);
		
		layer = layer_get_id("Projectiles_fg");
    }
    else
    {
        instance_destroy();
    }
}
else
{
	if(impacted < 2)
	{
		var gPoint = noone;
		
		if(impacted == 0)
		{
			while(grapSpeed > 0 && !lhc_collision_line(xprevious,yprevious,x+grapSignX,y+grapSignY,"ISolid",true,false))
		    {
		        grappleDist += 1;
				x = obj_Player.shootPosX+lengthdir_x(grappleDist,obj_Player.shootDir);
				y = obj_Player.shootPosY+lengthdir_y(grappleDist,obj_Player.shootDir);
		        grapSpeed -= 1;
		    }
			
			var col = collision_line(xprevious,yprevious,x+grapSignX,y+grapSignY,obj_Tile,true,false);
			if(instance_exists(col))
			{
				if(asset_has_any_tag(col.object_index, "IGrapplePoint", asset_object))
				{
					gPoint = col;
				}
				else
				{
					scr_OpenDoor(x+grapSignX,y+grapSignY,0);
			        scr_BreakBlock(x+grapSignX,y+grapSignY,0);
			        audio_stop_sound(snd_BeamImpact);
			        audio_play_sound(snd_BeamImpact,0,false);
			        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gTrail,7);
			        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gImpact,1);
			        impacted = 1;
				}
			}
			else if(point_distance(obj_Player.x, obj_Player.y, x, y) > obj_Player.grappleMaxDist-(grapSpeedMax/2))
		    {
		        impacted = 1;
		    }
		}
		else
		{
			grappleDist = max(grappleDist - grapSpeedMax, 0);
			x = obj_Player.shootPosX+lengthdir_x(grappleDist,obj_Player.shootDir);
		    y = obj_Player.shootPosY+lengthdir_y(grappleDist,obj_Player.shootDir);
			if(grappleDist <= 0)
			{
				impacted = 2;
			}
		}
		
		if(!instance_exists(gPoint))
		{
			for(var i = 0; i < point_distance(obj_Player.shootPosX,obj_Player.shootPosY,x,y); i++)
			{
				var ang = obj_Player.shootDir;
				var xx = obj_Player.shootPosX+lengthdir_x(i,ang),
					yy = obj_Player.shootPosY+lengthdir_y(i,ang);
				
				var bl_list = ds_list_create();
				var bl = collision_rectangle_list(xx-4,yy-4,xx+4,yy+4,all,false,true,bl_list,true)
				if(bl > 0)
				{
					for(var j = 0; j < bl; j++)
					{
						if(asset_has_any_tag(bl_list[| j].object_index,"IGrapplePoint",asset_object))
						{
							gPoint = bl_list[| j];
							x = xx;
							y = yy;
							break;
						}
					}
				}
				ds_list_destroy(bl_list);
			}
		}
	    if(instance_exists(gPoint))
	    {
	        audio_play_sound(snd_GrappleBeam_Latch,0,false);
	        grapBlock = gPoint;
			if(object_is_ancestor(grapBlock.object_index,obj_Tile))
			{
				grapBlockPosX = scr_floor(clamp(x,grapBlock.bbox_left,grapBlock.bbox_right-1)/16)*16 + 8;
				grapBlockPosY = scr_floor(clamp(y,grapBlock.bbox_top,grapBlock.bbox_bottom-1)/16)*16 + 8;
			}
	        grappled = true;
	    }
	}
	else
	{
		instance_destroy();
	}
}

if(damage > 0 && !grappled)
{
	for(var j = 0; j < grappleDist; j += 8)
	{
		var xw = x-lengthdir_x(j,obj_Player.shootDir),
			yw = y-lengthdir_y(j,obj_Player.shootDir);
		scr_DamageNPC(xw,yw,damage,damageType,damageSubType,0,-1,10);
	}
}