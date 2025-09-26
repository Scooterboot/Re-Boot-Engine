/// @description 
var screenX = scr_round(global.screenX),
	screenY = scr_round(global.screenY),
	screenW = global.resWidth*screenScale,
	screenH = global.resHeight*screenScale;

//display_set_gui_maximize(1, 1, 0, 0);

gpu_set_texfilter(false);
draw_clear_alpha(c_black,0);

if(surface_exists(finalAppSurf))
{
	surface_resize(finalAppSurf,screenW,screenH);
	surface_set_target(finalAppSurf);
	
	gpu_set_blendenable(false);
	draw_surface_ext(application_surface,0,0,screenScale/global.zoomScale,screenScale/global.zoomScale,0,c_white,1);
	gpu_set_blendenable(true);
	
	//gpu_set_blendmode_ext_sepalpha(bm_one, bm_inv_src_alpha, bm_src_alpha, bm_one);
	//gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
	draw_surface_ext(surfUI,0,0,screenScale,screenScale,0,c_white,1);
	//gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	
	gpu_set_blendenable(false);
	draw_surface_ext(finalAppSurf,screenX,screenY,1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
	finalAppSurf = surface_create(screenW,screenH);
}


if(keyboard_check_pressed(vk_f12))
{
    screen_save_part("screenshot.png",screenX,screenY,screenW,screenH);
}