alpha = abs(1 - (initDist/point_distance(x,y,destX,destY)));
angle = point_direction(x,y,destX,destY);
color = merge_colour(merge_colour(color1,color2,min(alpha*2,1)),color3,abs(max(alpha-0.5,0)*2));
gpu_set_blendmode(bm_add);
var num = 5;//vel;
for(i = 1; i < num; i++)
{
    draw_sprite_ext(sprite_index,0,x-lengthdir_x(i,angle),y-lengthdir_y(i,angle),1,1,0,color,(1-(i/num))*alpha);
}
for(i = 1; i < num; i++)
{
    draw_sprite_ext(sprite_index,0,x+lengthdir_x(i,angle),y+lengthdir_y(i,angle),1,1,0,color,(1-(i/num))*alpha);
}
draw_sprite_ext(sprite_index,0,x,y,1,1,0,color,alpha);
gpu_set_blendmode(bm_normal);