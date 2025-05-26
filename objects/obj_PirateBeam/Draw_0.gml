/// @description 

//var dist = clamp((point_distance(x,y,xstart,ystart) + sprite_xoffset)/sprite_width,0,1);
//image_xscale = dist;

scale = min(scale+point_distance(xprevious,yprevious,x,y),scaleMax);
image_xscale = scale/scaleMax;

image_angle = direction+180;
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,1);