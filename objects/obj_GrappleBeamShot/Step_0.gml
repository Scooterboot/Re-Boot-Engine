direction = 0;
speed = 0;

if(global.gamePaused)
{
    exit;
}

grapSpeed = grapSpeedMax;
grapSignX = lengthdir_x(1,obj_Player.shootDir);
grapSignY = lengthdir_y(1,obj_Player.shootDir);

if(grappled)
{
    if(instance_exists(grapBlock))
    {
        //x = grapBlock.x+8;
        //y = grapBlock.y+8;
		x = grapBlockPosX+8;
		y = grapBlockPosY+8;
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
        if(!audio_is_playing(snd_GrappleBeam_Loop) && !audio_is_playing(snd_GrappleBeam_Latch))
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
	var fx = x+lengthdir_x(grapSpeedMax,obj_Player.shootDir),
		fy = y+lengthdir_y(grapSpeedMax,obj_Player.shootDir);
	var gPoint = collision_rectangle(fx-1,fy-1,fx+1,fy+1,obj_GrappleBlock,false,false);
	var gPoint2 = collision_rectangle(fx-1,fy-1,fx+1,fy+1,obj_GrappleBlockCracked,false,false);
	if(instance_exists(gPoint2))
	{
		gPoint = gPoint2;
	}
	if(!instance_exists(gPoint))
	{
		for(var i = 0; i < point_distance(obj_Player.shootPosX,obj_Player.shootPosY,fx,fy); i++)
		{
			var ang = obj_Player.shootDir;//point_direction(obj_Player.shootPosX, obj_Player.shootPosY, fx, fy);
			var xx = obj_Player.shootPosX+lengthdir_x(i,ang),
				yy = obj_Player.shootPosY+lengthdir_y(i,ang);
			var gp = collision_rectangle(xx-4,yy-4,xx+4,yy+4,obj_GrappleBlock,false,true);
			var gp2 = collision_rectangle(xx-4,yy-4,xx+4,yy+4,obj_GrappleBlockCracked,false,true);
			if(instance_exists(gp2))
			{
				gp = gp2;
			}
			if(instance_exists(gp))
			{
				gPoint = gp;
				x = xx;
				y = yy;
				break;
			}
		}
	}
    if(instance_exists(gPoint))
    {
        audio_play_sound(snd_GrappleBeam_Latch,0,false);
        grapBlock = gPoint;
		grapBlockPosX = scr_floor(clamp(x,grapBlock.bbox_left,grapBlock.bbox_right-1)/16)*16;
		grapBlockPosY = scr_floor(clamp(y,grapBlock.bbox_top,grapBlock.bbox_bottom-1)/16)*16;
        grappled = true;
    }
	else if(impact <= 0)
	{
	    while(grapSpeed > 0 && !collision_line(xprevious-lengthdir_x(grapSpeedMax,obj_Player.shootDir),yprevious-lengthdir_y(grapSpeedMax,obj_Player.shootDir),x+grapSignX,y+grapSignY,obj_Tile,true,false))
	    {
	        x += grapSignX;
	        y += grapSignY;
	        grappleDist += 1;
	        grapSpeed -= 1;
	    }
	    x = obj_Player.shootPosX+lengthdir_x(grappleDist,obj_Player.shootDir);
	    y = obj_Player.shootPosY+lengthdir_y(grappleDist,obj_Player.shootDir);
		
		var col = collision_line(xprevious-grapSignX,yprevious-grapSignY,x+grapSignX,y+grapSignY,obj_Tile,true,false);
	    if(instance_exists(col) && col.object_index != obj_GrappleBlock && col.object_index != obj_GrappleBlockCracked)
	    {
	        scr_OpenDoor(x+grapSignX,y+grapSignY,0);
	        scr_BreakBlock(x+grapSignX,y+grapSignY,0);
	        audio_stop_sound(snd_BeamImpact);
	        audio_play_sound(snd_BeamImpact,0,false);
	        //audio_stop_sound(snd_GrappleBeam_Shoot);
	        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gTrail,7);
	        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.gImpact,1);
	        impact = 1;
	    }
	    else if(point_distance(obj_Player.x, obj_Player.y, x, y) > obj_Player.grappleMaxDist-(grapSpeedMax/2))//if(timeLeft <= 0)
	    {
	        impact = 1;
	    }
	    //timeLeft = max(timeLeft-1,0);
	}
	else if(impact == 1)
	{
		grappleDist = max(grappleDist - grapSpeedMax, 0);
		x = obj_Player.shootPosX+lengthdir_x(grappleDist,obj_Player.shootDir);
	    y = obj_Player.shootPosY+lengthdir_y(grappleDist,obj_Player.shootDir);
		if(grappleDist <= 0)
		{
			impact = 2;
		}
	}
	else if(impact >= 2)
	{
		instance_destroy();
	}
}

if(damage > 0)
{
	scr_DamageNPC(x,y,damage,damageType,0,-1,4);
}