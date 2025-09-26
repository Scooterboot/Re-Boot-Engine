/// @description Graphics
event_inherited();

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]);
var pos = SurfPos();

var fAlpha = alpha*image_alpha;

if(!global.GamePaused())
{
	imgIndex = scr_wrap(imgIndex + 0.2, 0, 8);
}

if(_SurfWidth() < 1 || _SurfHeight() < 1)
{
	exit;
}

AcidSurface();

if(surface_exists(finalSurface))
{
	surface_resize(finalSurface, SurfWidth(), SurfHeight());
	surface_set_target(finalSurface);
	
	gpu_set_blendenable(false);
	draw_surface_ext(application_surface,camX-pos.X,camY-pos.Y,1,1,0,c_white,1);
	gpu_set_blendenable(true);
	
	if(global.waterDistortion)
	{
		var fW = surface_get_width(finalSurface),
			fH = surface_get_height(finalSurface);
		
		var _x = -(camX-pos.X),
			_y = -(camY-pos.Y);
		var tex = surface_get_texture(application_surface),
		sW = surface_get_width(application_surface),
		sH = surface_get_height(application_surface);
		
		draw_primitive_begin_texture(pr_trianglestrip, tex);
		
		for (var i = bb_top()-y; i <= fH+6; i += 6)
		{
			var mult = -min(1.5,i/6);
			var spread = mult * sin(time + (i+pos.Y) / 4);
			
			draw_vertex_texture_color(0 + spread, i, _x/sW, (_y+i)/sH, c_white, 0.5);
			draw_vertex_texture_color(fW + spread, i, (_x+fW)/sW, (_y+i)/sH, c_white, 0.5);
		}
		
		draw_primitive_end();
	}
	
	if(instance_exists(obj_XRayVisor))
	{
		with(obj_XRayVisor)
		{
			gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

			draw_primitive_begin(pr_trianglelist);
			draw_vertex_colour(visorX-pos.X,visorY-pos.Y,0,0);
			draw_vertex_colour(visorX-pos.X+lengthdir_x(500,coneDir + coneSpread),visorY-pos.Y+lengthdir_y(500,coneDir + coneSpread),0,0);
			draw_vertex_colour(visorX-pos.X+lengthdir_x(500,coneDir - coneSpread),visorY-pos.Y+lengthdir_y(500,coneDir - coneSpread),0,0);
			draw_primitive_end();

			gpu_set_blendmode(bm_normal);
		}
	}
	
	gpu_set_blendmode(bm_add);
	draw_surface_ext(acidSurface,-spriteW/2,0,1,1,0,c_white,fAlpha);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	
	draw_surface_ext(finalSurface,pos.X,pos.Y,1,1,0,image_blend,image_alpha);
}
else
{
	finalSurface = surface_create(SurfWidth(), SurfHeight());
	surface_set_target(finalSurface);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}