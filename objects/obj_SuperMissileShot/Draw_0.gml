/// @description Draw
scr_PlasmaDraw(x,y,image_xscale,image_yscale,image_angle,image_alpha);
if((point_distance(x,y,xstart,ystart)/sprite_width) < 1)
{
    image_speed = 0;
    image_index = 0;
}
else
{
    image_speed = 0.3;
}