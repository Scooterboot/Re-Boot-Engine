/// @description Redraw Application Surface
application_surface_draw_enable(false);

surface_resize(application_surface,global.resWidth,global.resHeight);
draw_clear_alpha(c_black,0);

gpu_set_blendenable(false);
better_scaling_draw_surface(application_surface,scr_round(global.screenX),scr_round(global.screenY),screenScale,screenScale,0,c_white,1,global.upscale);
gpu_set_blendenable(true);