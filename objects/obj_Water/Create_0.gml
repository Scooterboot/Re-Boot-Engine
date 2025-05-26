/// 
event_inherited();

alpha = 0.45;

velX = 0.5;
moveY = true;

refractX = 0;
refractXSpeed = 1.0 / 3;

imgIndex = 0;
waterColor = merge_color(c_aqua,c_blue,0.85);
waterColorAlpha = 0.25;

waterSurface = surface_create(SurfWidth2(),SurfHeight2());
waterSurfaceRefractGlow = surface_create(SurfWidth2(),SurfHeight2());
waterSurfaceRefractMask = surface_create(SurfWidth2(),SurfHeight2());
waterSurfaceRefract = surface_create(SurfWidth2(),SurfHeight2());

finalSurface = surface_create(SurfWidth(),SurfHeight());

#region WaterSurface
function WaterSurface()
{
	if(surface_exists(waterSurface))
	{
		var pos = SurfPos();
		
		surface_resize(waterSurface,SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurface = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region GlowSurface
function GlowSurface()
{
	if(surface_exists(waterSurfaceRefractGlow))
	{
		var pos = SurfPos();
		
		surface_resize(waterSurfaceRefractGlow,SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefractGlow);
		draw_clear_alpha(c_black,0);
		
		var refMSprt = sprt_WaterRefractMask;
		draw_sprite_ext(refMSprt,scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurfaceRefractGlow = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefractGlow);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region MaskSurface
function MaskSurface()
{
	if(surface_exists(waterSurfaceRefractMask))
	{
		var pos = SurfPos();
		
		surface_resize(waterSurfaceRefractMask,SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefractMask);
		draw_clear_alpha(c_black,0);
		
		var refSprt = sprt_WaterRefract;
		
		var scaleX = image_xscale * (spriteW / sprite_get_width(refSprt)),
			scaleY = image_yscale * (spriteH / sprite_get_height(refSprt));
		
		draw_sprite_ext(refSprt,0,(x-pos.X)+(refractX-sprite_get_width(refSprt)/2),y-pos.Y,scaleX+2,scaleY+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurfaceRefractMask = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefractMask);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region Refract Surface
function RefractSurface()
{
	if(surface_exists(waterSurfaceRefract))
	{
		var pos = SurfPos();
		
		surface_resize(waterSurfaceRefract,SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefract);
		draw_clear_alpha(c_black,0);
		
		gpu_set_colorwriteenable(1,1,1,0);
		draw_surface_ext(waterSurfaceRefractMask,0,0,1,1,0,c_white,1);

		gpu_set_colorwriteenable(0,0,0,1);
		draw_surface_ext(waterSurfaceRefractGlow,0,0,1,1,0,c_white,1);

		gpu_set_colorwriteenable(1,1,1,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurfaceRefract = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(waterSurfaceRefract);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion

#region Draw distorted surface
function DrawDistortSurf(_surface, _x, _y, _alpha)
{
	var pos = SurfPos();
	
	var tex = surface_get_texture(_surface),
		sW = surface_get_width(_surface),
		sH = surface_get_height(_surface);
	
	draw_primitive_begin_texture(pr_trianglestrip, tex);
	
	var yoff = pos.Y-y;
	for(var i = 0; i <= scaledH()+spriteH; i += min(max(1,i)*6,32))
	{
		if(i >= yoff-32 && i <= yoff+sH+32)
		{
			var mult = min(12,i/3);
			var spread = mult * sin(time/2 + i/16) / 2.5;
			var alph = lerp(1,0.25,clamp((i-16)/32,0,1));
		
			draw_vertex_texture_color(_x+spread, _y+i-yoff, 0, (i-yoff)/sH, c_white, _alpha*alph);
			draw_vertex_texture_color(_x+sW+spread, _y+i-yoff, 1, (i-yoff)/sH, c_white, _alpha*alph);
		}
	}
	
	draw_primitive_end();
}
#endregion
