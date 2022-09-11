/// @description 
event_inherited();

velY = min(velY+0.375,8);

if(sign(velX) != 0)
{
	//image_xscale = sign(velX);
}
var rot = point_direction(x,y,x+velX,y+velY)+135;
image_angle = scr_round(rot/22.5)*22.5;