/// @description Initialize
event_inherited();

state = 0;
// 0 = idle, 1 = alerted, 2 = diving, 3 = digging

counter[0] = 0;
counter[1] = 0;

function OnYCollision(fVY, isOOB = false)
{
	if(fVY > 0 && state == 2)
	{
		state = 3;
	}
}

projIndex = obj_SkreeProjectile;

projFired = false;
function FireProjectiles()
{
	if(!projFired)
	{
		for(var i = 0; i < 4; i++)
		{
			//var ang = 45 + 30*i;
			var proj = instance_create_layer(x,y+12,"Projectiles_fg",projIndex);
			//proj.velX = lengthdir_x(3,ang);
			//proj.velY = lengthdir_y(3,ang);
			proj.velX = -2 + i + (i >= 2);
			proj.velY = -(3 + (i == 1 || i == 2));
		}
		projFired = true;
	}
}