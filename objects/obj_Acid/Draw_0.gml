/// @description Graphics
event_inherited();

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]);

var fAlpha = alpha*image_alpha;

if(!global.gamePaused)
{
	imgIndex = scr_wrap(imgIndex + 0.2, 0, 8);
}

surfWidth = scaledW() + spriteW;
surfHeight = scaledH() + spriteH;
AcidSurface();

if(surface_exists(finalSurface))
{
	surface_resize(finalSurface, ceil(scaledW()), ceil(scaledH()));
	surface_set_target(finalSurface);
	
	draw_surface_ext(application_surface,-(x-camX),-(y-camY),1,1,0,c_white,1);
	
	if(global.waterDistortion)
	{
		var fW = surface_get_width(finalSurface),
			fH = surface_get_height(finalSurface);
		
		var _x = (x-camX),
			_y = (y-camY);
		var tex = surface_get_texture(application_surface),
		sW = surface_get_width(application_surface),
		sH = surface_get_height(application_surface);
		
		draw_primitive_begin_texture(pr_trianglestrip, tex);
		
		for (var i = bbox_top-y; i < fH; i += 6)
		{
			var mult = -min(1.5,i/6);
			var spread = mult * sin(time+i/4+y/4);
			
			draw_vertex_texture_color(0 + spread, i, _x/sW, (_y+i)/sH, c_white, 0.5);
			draw_vertex_texture_color(fW + spread, i, (_x+fW)/sW, (_y+i)/sH, c_white, 0.5);
		}
		
		draw_primitive_end();
	}
	gpu_set_blendmode(bm_add);
	draw_surface_ext(acidSurface,-spriteW/2,0,1,1,0,c_white,fAlpha);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	
	draw_surface_ext(finalSurface,scr_round(x),scr_round(y),1,1,0,image_blend,image_alpha);
}
else
{
	finalSurface = surface_create(ceil(scaledW()), ceil(scaledH()));
	surface_set_target(finalSurface);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}