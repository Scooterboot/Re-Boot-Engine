/// @description 
if(!scr_RectangleWithinCam(bbox_left,bbox_top,bbox_right,bbox_bottom))
{
	exit;
}

self.DrawBreakable(x,y,image_index,0);
if(up)
{
	self.DrawBreakable(x,y,image_index,1);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(glowSprt,0,x,y,image_xscale/2,image_yscale/2,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}
if(down)
{
	self.DrawBreakable(x,y,image_index,2);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(glowSprt,1,x,y,image_xscale/2,image_yscale/2,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}
if(left)
{
	self.DrawBreakable(x,y,image_index,3);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(glowSprt,2,x,y,image_xscale/2,image_yscale/2,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}
if(right)
{
	self.DrawBreakable(x,y,image_index,4);
	
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(glowSprt,3,x,y,image_xscale/2,image_yscale/2,image_angle,c_white,glowAlpha);
	gpu_set_blendmode(bm_normal);
}