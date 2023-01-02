/// @description 
event_inherited();
if(PauseAI())
{
	exit;
}

if(state == 0) // idle
{
	if(instance_exists(obj_Player))
	{
		if(obj_Player.bbox_top > bbox_top && obj_Player.bbox_bottom < bbox_top+240)
	    {
	        var ydif = obj_Player.y-bbox_top;
	        if(obj_Player.bbox_right > bbox_left-((ydif/2)+1) && obj_Player.bbox_left < bbox_right+((ydif/2)+1))
	        {
				var tileCheck = lhc_collision_line(x,y,obj_Player.x,obj_Player.y,"ISolid",true,true);
				if(!tileCheck)
				{
					state = 1;
				}
	        }
	    }
	}
}
if(state == 1) // alerted
{
	counter[0]++;
	if(counter[0] > 20)
	{
		state = 2;
	}
}
if(state == 2) // dive
{
	if(instance_exists(obj_Player) && velX == 0)
    {
        var ang = clamp(point_direction(x,y,obj_Player.x,obj_Player.y),225,315);
        velX = lengthdir_x(8,ang);
    }
    velY = 7;
	
	Collision_Normal(velX,velY,16,16,false);
}
if(state == 3) // dig
{
	if(counter[0] > 20)
	{
		FireProjectiles();
	}
	
	velY = 1;
	y += velY;
	
	counter[0]++;
	if(counter[0] > 60)
	{
		//dead = true;
		//NPCLoot(x,y);
		instance_destroy();
	}
}