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
		if(obj_Player.bb_top() > bb_top() && obj_Player.bb_bottom() < bb_top()+240)
	    {
	        var ydif = obj_Player.y-bb_top();
	        if(obj_Player.bb_right() > bb_left()-((ydif/2)+1) && obj_Player.bb_left() < bb_right()+((ydif/2)+1))
	        {
				if(!collision_line(x,y,obj_Player.x,obj_Player.y,solids,true,true))
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
	
	Collision_Normal(velX,velY,false);
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
		instance_destroy();
	}
}