/// @description Code
event_inherited();

if(!global.gamePaused)
{
    //velocity = min(velocity * 1.1, 15.75);
	velX = min(abs(velX) * 1.1, abs(lengthdir_x(15.75,direction)))*sign(velX);
	velY = min(abs(velY) * 1.1, abs(lengthdir_y(15.75,direction)))*sign(velY);
	var velocity = point_distance(0,0,velX,velY);
    if(particleDelay <= 0)
    {
		if(!liquid)
		{
			part_particles_create(obj_Particles.partSystemC,x-lengthdir_x(12,direction),y-lengthdir_y(12,direction),obj_Particles.mTrail[1],1);
			particleDelay = 5 / (1 + (velocity-(8/3))*0.25);
		}
		else
		{
			var x1 = bb_left()+2, x2 = bb_right()-2,
				y1 = bb_top()+2, y2 = bb_bottom()-2;
			var bub = liquid.CreateBubble(random_range(x1,x2),random_range(y1,y2),0,0);
			bub.spriteIndex = sprt_WaterBubble;
			bub.kill = true;
			bub.canSpread = (irandom(1) == 0);
			bub.alpha = 0.7 + random(0.2);
			bub.maxSpeed /= (1 + random(0.3));
		}
    }
    particleDelay = max(particleDelay - 1, 0);
}