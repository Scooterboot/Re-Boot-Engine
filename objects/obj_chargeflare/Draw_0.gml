/// @description 

if(sprite_index == sprt_HyperBeamChargeFlare)
{
	pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
}
draw_sprite_ext(sprite_index,frame,x,y,image_xscale,image_yscale,image_angle,c_white,1);
shader_reset();