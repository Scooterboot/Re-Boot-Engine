/// @description Code
event_inherited();
water_update(0,x-xprevious,y-yprevious);
if(!global.gamePaused)
{
    velocity = min(velocity * 1.1, 15.75);
    if(particleDelay <= 0)
    {
        if(!InWater)
		{
			part_particles_create(obj_Particles.partSystemC,x-lengthdir_x(12,direction),y-lengthdir_y(12,direction),obj_Particles.mTrail[1],1);
			particleDelay = 5 / (1 + (velocity-(8/3))*0.25);
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
    particleDelay = max(particleDelay - 1, 0);
}