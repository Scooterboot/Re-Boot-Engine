
var visorX = scr_round(x), visorY = scr_round(y);

var _width = sprite_get_width(sprt_ScanReticle);
var scanSpread = scanAnim * scanAlpha;
var retScale1 = lerp(_width-2, _width+8, scanSpread) / _width,
	retScale2 = lerp(_width, _width+14, scanSpread) / _width;

if(!surface_exists(darkSurf))
{
	darkSurf = surface_create(global.resWidth, global.resHeight);
}
if(surface_exists(darkSurf))
{
	surface_set_target(darkSurf);
	draw_clear_alpha(c_black,1);
	
	gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);
	draw_set_alpha(0);
	draw_circle(visorX-1, visorY-1, _width*0.75*retScale2, false);
	draw_set_alpha(1);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
}

surface_set_target(obj_Display.surfUI);
bm_set_one();

draw_surface_ext(darkSurf, 0,0, 1,1, 0, c_white, 0.625*scanAlpha);

draw_sprite_ext(sprt_ScanReticle, 1, visorX, visorY, retScale1, retScale1, 0,c_white,scanAlpha);
draw_sprite_ext(sprt_ScanReticle, 0, visorX, visorY, retScale2, retScale2, 0,c_white,scanAlpha);

gpu_set_blendmode(bm_normal);
surface_reset_target();