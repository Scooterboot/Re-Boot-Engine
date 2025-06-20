/// @description 
if(!scr_RectangleWithinCam(bbox_left,bbox_top,bbox_right,bbox_bottom))
{
	exit;
}

var _index = 0,
	_xscale = image_xscale,
	_yscale = image_yscale;
if(abs(image_xscale) >= 1.5)
{
	_index = 4;
	_xscale = image_xscale/2;
}
if(abs(image_yscale) >= 1.5)
{
	_index = 8;
	_yscale = image_yscale/2;
}

draw_sprite_ext(extSprt,_index,x,y,_xscale,_yscale,image_angle,c_white,1);
if((up && image_yscale > 0) || (down && image_yscale < 0) || (right && image_xscale > 0) || (left && image_xscale < 0))
{
	draw_sprite_ext(extSprt,_index+1,x,y,_xscale,_yscale,image_angle,c_white,1);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(extSprt,_index+1,x,y,_xscale,_yscale,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}
if((down && image_yscale > 0) || (up && image_yscale < 0))
{
	draw_sprite_ext(extSprt,_index+2,x,y,_xscale,_yscale,image_angle,c_white,1);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(extSprt,_index+2,x,y,_xscale,_yscale,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}
if((left && image_xscale > 0) || (right && image_xscale < 0))
{
	draw_sprite_ext(extSprt,_index+3,x,y,_xscale,_yscale,image_angle,c_white,1);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(extSprt,_index+3,x,y,_xscale,_yscale,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}