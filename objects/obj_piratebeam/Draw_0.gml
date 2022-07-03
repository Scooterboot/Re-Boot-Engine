/// @description 

var dist = clamp((point_distance(xstart,ystart,x,y) + sprite_xoffset)/sprite_width,0,1);
image_xscale = dist;

draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle-180,c_white,1);