/// @description Trail
event_inherited();

if(!global.GamePaused())
{
	velX = min(abs(velX) * 1.05, abs(lengthdir_x(10,direction)))*sign(velX);
	velY = min(abs(velY) * 1.05, abs(lengthdir_y(10,direction)))*sign(velY);
	
    particleDelay = max(particleDelay - 1, 0);
    if(particleDelay <= 0)
    {
		if(!liquid)
		{
			part_particles_create(obj_Particles.partSystemC,x-fVelX,y-fVelY,obj_Particles.mTrail[0],1);
			particleDelay = 3;
		}
		else
		{
			var x1 = bb_left()+2, x2 = bb_right()-2,
				y1 = bb_top()+2, y2 = bb_bottom()-2;
			var bub = liquid.CreateBubble(random_range(x1,x2),random_range(y1,y2),0,0);
			bub.kill = true;
			bub.canSpread = (irandom(1) == 0);
			bub.alpha = 0.7 + random(0.2);
			bub.maxSpeed /= (1 + random(0.3));
		}
    }
}