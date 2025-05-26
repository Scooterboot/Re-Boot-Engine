/// @description 

var imgAng = scr_wrap(image_angle,0,360);
var angleNum = scr_round(imgAng/45);
var angle = imgAng - 45*angleNum;

var imgNum = array(0,1,2,1,0,1,2,1),
	imgXScale = array(1,1,1,1,1,-1,-1,-1),
	imgYScale = array(1,1,1,-1,-1,-1,1,1),
	index = scr_wrap(angleNum,0,8),
	xoff = lengthdir_x(7,imgAng+90),
	yoff = lengthdir_y(7,imgAng+90);

draw_sprite_ext(sprt_Reflec_Panel,imgNum[index],
	x+scr_round(xoff),y+scr_round(yoff),
	image_xscale*imgXScale[index],image_yscale*imgYScale[index],
	angle,image_blend,image_alpha);

draw_sprite_ext(sprt_Reflec_Body,angleNum,
	x,y,
	image_xscale,image_yscale,
	angle,image_blend,image_alpha);