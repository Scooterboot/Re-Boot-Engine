
draw_sprite_ext(sprite_index,frame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);

if(hitAnim mod 4 >= 2)
{
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprite_index,frame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
	gpu_set_blendmode(bm_normal);
}