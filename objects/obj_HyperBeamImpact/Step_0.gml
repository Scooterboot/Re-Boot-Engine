/// @description 

self.TileInteract(x,y);

self.DamageBoxes();

frameCounter++;
if(frameCounter > 1)
{
	frame++;
	frameCounter = 0;
}
image_index = frame;
if(image_index >= image_number)
{
	instance_destroy();
}