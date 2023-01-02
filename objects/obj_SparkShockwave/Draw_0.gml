/// @description 

var rFrame = 0;

image_angle = direction;
var angle = direction;
if((direction-45)%90 == 0 && rotFrame > 0)
{
	rFrame = rotFrame;
	angle = direction-45;
}
image_index = rFrame+frame;

gpu_set_blendmode(bm_add);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,angle,c_white,0.7);
gpu_set_blendmode(bm_normal);