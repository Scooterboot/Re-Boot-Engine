/// @description Redraw Application Surface
application_surface_draw_enable(false);

var filter = false,
	upScale = global.upscale;
if(global.upscale == 1)
{
	filter = true;
	upScale = 0;
}
gpu_set_texfilter(filter);

surface_resize(application_surface,global.resWidth,global.resHeight);
draw_clear_alpha(c_black,0);

gpu_set_blendenable(false);
if(global.upscale == 7)
{
	surface_resize(application_surface,global.resWidth*screenScale,global.resHeight*screenScale);
	draw_surface_ext(application_surface,scr_round(global.screenX),scr_round(global.screenY),1,1,0,c_white,1);
}
else
{
	surface_resize(application_surface,global.resWidth,global.resHeight);
	if(global.upscale == 6)
	{
		shader_set(shd_Scanlines);
		shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "u_crt_sizes"), global.resWidth,global.resHeight, global.resWidth*screenScale,global.resHeight*screenScale);
		shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "distort"), false);
		shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "distortion"), 0.12);
		shader_set_uniform_f(shader_get_uniform(shd_Scanlines, "border"), false);
		draw_surface_ext(application_surface,scr_round(global.screenX),scr_round(global.screenY),screenScale,screenScale,0,c_white,1);
		shader_reset();
	}
	else
	{
		better_scaling_draw_surface(application_surface,scr_round(global.screenX),scr_round(global.screenY),screenScale,screenScale,0,c_white,1,upScale);
	}
}
gpu_set_blendenable(true);