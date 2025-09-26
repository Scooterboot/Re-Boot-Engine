/// @description Draw

if(!global.GamePaused())
{
	xstart += speed_x;
	ystart += speed_y;
}
var dist = clamp((point_distance(x,y,xstart,ystart) + 4 + sprite_xoffset)/sprite_width,0,1);

if(dist < 1)
{
    image_speed = 0;
    image_index = 0;
}
else
{
    image_speed = 0.3;
}

var angle = direction+180;
var xscale = dist;
draw_sprite_ext(sprite_index,image_index,x,y,xscale,image_yscale,angle,c_white,1);