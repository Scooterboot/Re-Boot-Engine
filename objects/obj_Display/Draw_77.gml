/// @description Redraw Application Surface
/*application_surface_draw_enable(false);

gpu_set_texfilter(false);
draw_clear_alpha(c_black,0);

var screenX = scr_round(global.screenX),
	screenY = scr_round(global.screenY),
	screenW = global.resWidth*screenScale,
	screenH = global.resHeight*screenScale;

var _scissor = gpu_get_scissor();
gpu_set_scissor(screenX,screenY,screenW,screenH);

gpu_set_blendenable(false);
if(global.upscale == 6)
{
	shader_set(shd_Scanlines);
	shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "u_crt_sizes"), global.zoomResWidth,global.zoomResHeight, global.resWidth*screenScale,global.resHeight*screenScale);
	shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "distort"), true);//false);
	shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "distortion"), 0.18);//0.12);
	shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "border"), true);//false);
	draw_surface_ext(application_surface,screenX,screenY,screenScale/global.zoomScale,screenScale/global.zoomScale,0,c_white,1);
	shader_reset();
}
else
{
	better_scaling_draw_surface(application_surface,screenX,screenY,screenScale/global.zoomScale,screenScale/global.zoomScale,0,c_white,1,global.upscale);
}
gpu_set_blendenable(true);

gpu_set_scissor(_scissor);
/*if(surface_exists(finalAppSurf))
{
	surface_resize(finalAppSurf,screenW,screenH);
	surface_set_target(finalAppSurf);
	
	gpu_set_blendenable(false);
	draw_surface_ext(application_surface,0,0,screenScale/global.zoomScale,screenScale/global.zoomScale,0,c_white,1);
	gpu_set_blendenable(true);
	
	//gpu_set_colorwriteenable(1,1,1,0);
	//draw_surface_ext(surfUI,0,0,screenScale,screenScale,0,c_white,1);
	//gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
	
	gpu_set_blendenable(false);
	draw_surface_ext(finalAppSurf,screenX,screenY,1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
	finalAppSurf = surface_create(screenW,screenH);
}*/

//if(keyboard_check_pressed(vk_f12))
//{
//    screen_save_part("screenshot.png",screenX,screenY,screenW,screenH);
//}