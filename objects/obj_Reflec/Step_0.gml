/// @description 

var grap = collision_circle(x,y,8,obj_GrappleBeamShot,true,true);
if(instance_exists(grap) && grap.impacted <= 0)
{
	image_angle += rotStep;
	grap.impacted = 1;
}