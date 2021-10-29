/// @description Gradient

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

draw_set_alpha(Alpha);
gpu_set_blendmode(bm_add);
draw_rectangle_color(xx,y-16*Height+32,xx+ww,y+32,0,0,Color,Color,0);
draw_rectangle_color(xx,y+48*Height+32,xx+ww,y+32,Color,Color,0,0,0);
gpu_set_blendmode(bm_normal);