/// @description 
event_inherited();

if(PauseAI())
{
    exit;
}


velX = mSpeed*dir;

var fspeed = mSpeed;
if(frame < 3)
{
	frame += fspeed;
}
else
{
	frame = scr_wrap(frame+fspeed,3,27);
}
currentFrame = scr_floor(frame);


grounded = (entity_place_collide(0,1) || (bbox_bottom+1) >= room_height);// && velY == 0);
fGrav = grav[InWater];

if(!grounded)
{
    velY = min(velY+fGrav, maxGrav);
}

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,16,16,true);