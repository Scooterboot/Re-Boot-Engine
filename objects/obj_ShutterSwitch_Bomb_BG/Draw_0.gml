/// @description 
if(!instance_exists(bSwitch))
{
	instance_destroy();
	exit;
}

draw_sprite_ext(sprite_index,bSwitch.frame-2,bSwitch.x,bSwitch.y,bSwitch.image_xscale,bSwitch.image_yscale,bSwitch.image_angle,bSwitch.image_blend,bSwitch.image_alpha);
