/// @description Anim

var alph = min(timeLeft/(timeLeftMax/2),1);
var alph2 = 1-(timeLeft/timeLeftMax);

draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,alph);

gpu_set_fog(true,c_white,0,0);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,alph2*alph);
gpu_set_fog(false,0,0,0);