
if(InputPlayerGetDevice() == INPUT_KBM && instance_exists(obj_Mouse)) // && visor uses mouse for control == true
{
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	var cx = obj_Mouse.PosX(),
		cy = obj_Mouse.PosY();
	
	var sO = 8,
		sI = 4;
	draw_set_color(c_aqua);
	draw_set_alpha(0.3*alpha);
	draw_circle(cx, cy, sO, false);
	draw_set_color(c_white);
	draw_set_alpha(0.4*alpha);
	draw_circle(cx, cy, sI, false);
	draw_circle(cx, cy, sO, true);
	draw_set_alpha(1);
	
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}