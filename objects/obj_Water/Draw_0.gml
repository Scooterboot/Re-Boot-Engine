/// 
event_inherited();

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]);

var refSprt = sprt_WaterRefract;
refractX = scr_wrap(refractX+refractXSpeed,-sprite_get_width(refSprt)/2,sprite_get_width(refSprt)/2);

var fAlpha = alpha*image_alpha;

if(!global.gamePaused)
{
	imgIndex = scr_wrap(imgIndex + 0.075, 0, 6);
}

gpu_set_blendmode(bm_add);
draw_set_alpha(fAlpha/4);
draw_set_color(waterColor);
draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
draw_set_color(c_white);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

surfWidth = scaledW() + spriteW;
surfHeight = scaledH() + spriteH;

WaterSurface();
GlowSurface();
MaskSurface();
RefractSurface();

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
		
		for (var i = 0; i < fH; i += 6)
		{
			var mult = -min(1.5,i/6);
			var spread = mult * sin(time+i/4+y/4);
			
			draw_vertex_texture_color(0 + spread, i, _x/sW, (_y+i)/sH, c_white, 0.5);
			draw_vertex_texture_color(fW + spread, i, (_x+fW)/sW, (_y+i)/sH, c_white, 0.5);
		}
		
		draw_primitive_end();
	}
	
	gpu_set_blendmode(bm_add);
	DrawDistortSurf(waterSurface,-spriteW/2,0,fAlpha);
	DrawDistortSurf(waterSurfaceRefract,-spriteW/2,0,1);
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