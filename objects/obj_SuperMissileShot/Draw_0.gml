/// @description Draw
//scr_PlasmaDraw(x,y,image_xscale,image_yscale,image_angle,image_alpha);

if(!global.gamePaused)
{
	xstart += speed_x;
	ystart += speed_y;
}
var dist = clamp((point_distance(x,y,xstart,ystart) + sprite_xoffset)/sprite_width,0,1);
image_xscale = dist;

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
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,angle,c_white,1);