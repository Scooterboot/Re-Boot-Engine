/// 
event_inherited();

alpha = 0.45;

velX = 0.5;
moveY = true;

refractX = 0;
refractXSpeed = 1.0 / 3;

imgIndex = 0;
waterColor = merge_color(c_aqua,c_blue,0.85);

surfWidth = scaledW() + spriteW;
surfHeight = scaledH() + spriteH;

waterSurface = surface_create(surfWidth,surfHeight);
waterSurfaceRefractGlow = surface_create(surfWidth,surfHeight);
waterSurfaceRefractMask = surface_create(surfWidth,surfHeight);
waterSurfaceRefract = surface_create(surfWidth,surfHeight);

finalSurface = surface_create(ceil(scaledW()), ceil(scaledH()));

#region WaterSurface

function WaterSurface()
{
	if(surface_exists(waterSurface))
	{
		surface_resize(waterSurface, surfWidth,surfHeight);
		surface_set_target(waterSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),posX,0,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurface = surface_create(surfWidth,surfHeight);
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
		surface_resize(waterSurfaceRefractGlow,surfWidth,surfHeight);
		surface_set_target(waterSurfaceRefractGlow);
		draw_clear_alpha(c_black,0);
		
		var refMSprt = sprt_WaterRefractMask;
		draw_sprite_ext(refMSprt,scr_floor(imgIndex),posX,0,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurfaceRefractGlow = surface_create(surfWidth,surfHeight);
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
		surface_resize(waterSurfaceRefractMask,surfWidth,surfHeight);
		surface_set_target(waterSurfaceRefractMask);
		draw_clear_alpha(c_black,0);
		
		var refSprt = sprt_WaterRefract;
		
		var scaleX = image_xscale * (spriteW / sprite_get_width(refSprt)),
			scaleY = image_yscale * (spriteH / sprite_get_height(refSprt));
		
		draw_sprite_ext(refSprt,0,refractX-spriteW/2,0,scaleX+2,scaleY+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		waterSurfaceRefractMask = surface_create(surfWidth,surfHeight);
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
		surface_resize(waterSurfaceRefract,surfWidth,surfHeight);
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
		waterSurfaceRefract = surface_create(surfWidth,surfHeight);
		surface_set_target(waterSurfaceRefract);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}

#endregion

#region Draw distorted surface

function DrawDistortSurf(_surface, _x, _y, _alpha)
{
	var tex = surface_get_texture(_surface),
		sW = surface_get_width(_surface),
		sH = surface_get_height(_surface);
	
	draw_primitive_begin_texture(pr_trianglestrip, tex);
	
	for (var i = 0; i < sH; i += min(max(1,i)*6,32))
	{
		var mult = min(12,i/3);
		var spread = mult * sin(time/2 + i/16) / 2.5;
		/*var alph = 1;
		if(i > 64)//16)
		{
			alph = max(1 - 0.25*((i-64) / min(max(1,i)*6,32)), 0.25);
		}*/
		var alph = lerp(1,0.25,clamp((i-16)/32,0,1));
		
		draw_vertex_texture_color(_x+spread, _y+i, 0, i/sH, c_white, _alpha*alph);
		draw_vertex_texture_color(_x+sW+spread, _y+i, 1, i/sH, c_white, _alpha*alph);
	}
	
	draw_primitive_end();
}

#endregion
