/// @description 

if(sprite_index == sprt_HyperBeamChargeFlare)
{
	chameleon_set(sprt_HyperBeamPalette,obj_Display.hyperRainbowCycle,0,0,11);
}
draw_sprite_ext(sprite_index,frame,x,y,image_xscale,image_yscale,image_angle,c_white,1);
shader_reset();