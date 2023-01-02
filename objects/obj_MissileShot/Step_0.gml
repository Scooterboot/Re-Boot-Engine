/// @description Trail
event_inherited();

if(!global.gamePaused)
{
	velX = min(abs(velX) * 1.05, abs(lengthdir_x(10,direction)))*sign(velX);
	velY = min(abs(velY) * 1.05, abs(lengthdir_y(10,direction)))*sign(velY);
	
    particleDelay = max(particleDelay - 1, 0);
    if(particleDelay <= 0)
    {
		if(!InWater)
		{
			//part_particles_create(obj_Particles.partSystemC,x-lengthdir_x(velocity,direction),y-lengthdir_y(velocity,direction),obj_Particles.mTrail[0],1);
			part_particles_create(obj_Particles.partSystemC,x-fVelX,y-fVelY,obj_Particles.mTrail[0],1);
			particleDelay = 3;
		}
		else
		{
			var x1 = bbox_left+2, x2 = bbox_right-1,
            y1 = bbox_top+2, y2 = bbox_bottom-1;
	        var D = instance_create_layer(random_range(x1,x2),random_range(y1,y2),"Liquids_fg",obj_WaterBubble);
	        D.Delete = 1;
	        D.CanSpread = choose(0,1);
	        D.Alpha = .7 + random(.2);
	        D.MaxSpeed /= (1 + random(.3));
		}
    }
}