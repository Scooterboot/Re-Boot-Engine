/// @description 
event_inherited();
if(global.GamePaused())
{
	exit;
}

layer = layer_get_id("Projectiles_fg");

velX = min(abs(velX) * 1.075, abs(lengthdir_x(12,direction)))*sign(velX);
velY = min(abs(velY) * 1.075, abs(lengthdir_y(12,direction)))*sign(velY);

image_xscale = max(image_xscale*0.985,0.7);
image_yscale = max(image_yscale*0.985,0.7);

frameCounter++;
if(frameCounter >= 1+(frame == 0))
{
	frame = scr_wrap(frame+1,0,4);
	frameCounter = 0;
}