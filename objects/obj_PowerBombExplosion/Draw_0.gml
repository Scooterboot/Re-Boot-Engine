/// @description Draw

var x1 = bb_left(0),
	y1 = bb_top(0),
	x2 = bb_right(0),
	y2 = bb_bottom(0);

draw_set_color(c_yellow);

draw_set_alpha(image_alpha*0.75);
draw_ellipse(x+x1*0.75,y+y1,x+x2*0.75,y+y2,false);
draw_set_alpha(image_alpha);

gpu_set_blendmode(bm_add);
draw_set_color(make_color_rgb(255,225,0));
draw_ellipse(x+x1,y+y1*0.75,x+x2,y+y2*0.75,false);
draw_set_color(c_white);
draw_ellipse(x+x1,y+y1,x+x2,y+y2,false);
gpu_set_blendmode(bm_normal);

draw_set_circle_precision(64);

draw_set_color(c_white);
draw_set_alpha(1);