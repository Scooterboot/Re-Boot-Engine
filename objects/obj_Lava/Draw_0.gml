/// @description Graphics
event_inherited();

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]);
var pos = SurfPos();

draw_set_alpha(gradAlpha);
gpu_set_blendmode(bm_add);

draw_rectangle_color(bb_left(),bb_top()-32,bb_right(),bb_top(),0,0,gradCol,gradCol,false);
draw_rectangle_color(bb_left(),bb_top()+64,bb_right(),bb_top(),gradCol,gradCol,0,0,false);

for(var i = 1; i < 16; i++)
{
	draw_set_alpha(gradAlpha*((17-i)/16));
	
	draw_line_color(bb_left()-i,bb_top()-32,bb_left()-i,bb_top(),0,gradCol);
	draw_line_color(bb_right()+i,bb_top()-32,bb_right()+i,bb_top(),0,gradCol);
	
	draw_line_color(bb_left()-i,bb_top()+64,bb_left()-i,bb_top(),0,gradCol);
	draw_line_color(bb_right()+i,bb_top()+64,bb_right()+i,bb_top(),0,gradCol);
}

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);

var fAlpha = alpha*image_alpha;

if(!global.gamePaused)
{
	imgIndex = scr_wrap(imgIndex + 0.2, 0, 8);
}

if(_SurfWidth() < 1 || _SurfHeight() + extraDistH < 1)
{
	exit;
}

LavaSurface();

if(surface_exists(finalSurface))
{
	surface_resize(finalSurface, SurfWidth(), SurfHeight() + extraDistH);
	surface_set_target(finalSurface);
	
	gpu_set_blendenable(false);
	draw_surface_ext(application_surface,camX-pos.X,camY-pos.Y + extraDistH,1,1,0,c_white,1);
	gpu_set_blendenable(true);
	
	if(global.waterDistortion)
	{
		var fW = surface_get_width(finalSurface),
			fH = surface_get_height(finalSurface);
		
		var _x = -(camX-pos.X),
			_y = -(camY-pos.Y)-extraDistH;
		var tex = surface_get_texture(application_surface),
		sW = surface_get_width(application_surface),
		sH = surface_get_height(application_surface);
		
		draw_primitive_begin_texture(pr_trianglestrip, tex);
		
		for (var i = 0; i <= fH+6; i += 6)
		{
			var mult = -min(1.5,i/6);
			var spread = mult * sin(time + (i+pos.Y) / 4);
			if(i < extraDistH)
			{
				spread *= i/extraDistH;
			}
			
			draw_vertex_texture_color(0 + spread, i, _x/sW, (_y+i)/sH, c_white, 0.5);
			draw_vertex_texture_color(fW + spread, i, (_x+fW)/sW, (_y+i)/sH, c_white, 0.5);
		}
		
		draw_primitive_end();
	}
	
	if(instance_exists(obj_XRayVisor))
	{
		var px = pos.X,
			py = pos.Y-extraDistH;
		with(obj_XRayVisor)
		{
			gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

			draw_primitive_begin(pr_trianglelist);
			draw_vertex_colour(visorX-px,visorY-py,0,0);
			draw_vertex_colour(visorX-px+lengthdir_x(500,coneDir + coneSpread),visorY-py+lengthdir_y(500,coneDir + coneSpread),0,0);
			draw_vertex_colour(visorX-px+lengthdir_x(500,coneDir - coneSpread),visorY-py+lengthdir_y(500,coneDir - coneSpread),0,0);
			draw_primitive_end();

			gpu_set_blendmode(bm_normal);
		}
	}
	
	gpu_set_blendmode(bm_add);
	draw_surface_ext(lavaSurface,-spriteW/2,extraDistH,1,1,0,c_white,fAlpha);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	
	draw_surface_ext(finalSurface,pos.X,pos.Y-extraDistH,1,1,0,image_blend,image_alpha);
}
else
{
	finalSurface = surface_create(SurfWidth(), SurfHeight() + extraDistH);
	surface_set_target(finalSurface);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}