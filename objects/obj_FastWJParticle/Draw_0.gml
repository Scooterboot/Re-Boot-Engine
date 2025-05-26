/// @description 

alpha = 1;
if(time >= timeLeft*0.75)
{
	alpha = 1 - (max(time-(timeLeft*0.75),0) / (timeLeft*0.25));
}
//var color = merge_color(color2,color1,alpha);
var color = merge_color(color1, color2, max(time-(timeLeft*0.5),0) / (timeLeft*0.5));
alpha *= alphaMult;

gpu_set_colorwriteenable(1,1,1,0);
var num = 5;
for(var i = 1; i < num; i++)
{
    draw_sprite_ext(sprite_index,0,x-lengthdir_x(i,ang),y-lengthdir_y(i,ang),1,1,0,color,(1-(i/num))*alpha);
}
for(var i = 1; i < num; i++)
{
    draw_sprite_ext(sprite_index,0,x+lengthdir_x(i,ang),y+lengthdir_y(i,ang),1,1,0,color,(1-(i/num))*alpha);
}
draw_sprite_ext(sprite_index,0,x,y,1,1,0,color,alpha);
gpu_set_colorwriteenable(1,1,1,1);