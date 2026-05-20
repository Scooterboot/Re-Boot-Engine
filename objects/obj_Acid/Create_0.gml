/// @description Initialize
event_inherited();

liquidType = LiquidType.Acid;

alpha = 0.75;

moveY = true;

imgIndex = 0;

acidSurface = surface_create(SurfWidth2(),SurfHeight2());

finalSurface = surface_create(SurfWidth(),SurfHeight());

function AcidSurface()
{
	if(surface_exists(acidSurface))
	{
		var pos = SurfPos();
		
		surface_resize(acidSurface,SurfWidth2(),SurfHeight2());
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		acidSurface = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(acidSurface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}

#region Draw distorted surface
function DrawDistortSurf(_surface, _x, _y, _alpha)
{
	var pos = SurfPos();
	
	var tex = surface_get_texture(_surface),
		sW = surface_get_width(_surface),
		sH = surface_get_height(_surface);
	
	draw_primitive_begin_texture(pr_trianglestrip, tex);
	
	var yoff = pos.Y-y;
	for(var i = 0; i <= scaledH()+spriteH; i += min(max(8,i),32))
	{
		if(i >= yoff-32 && i <= yoff+sH+32)
		{
			var mult = min(12,i/3);
			var spread = mult * sin(time/2 + i/16) / 2.5;
			
			if(i <= 0)
			{
				draw_vertex_texture_color(_x, _y-yoff, 0, (-yoff)/sH, c_white, _alpha);
				draw_vertex_texture_color(_x+sW, _y-yoff, 1, (-yoff)/sH, c_white, _alpha);
			}
			var i2 = i+self.bb_top(0);
			draw_vertex_texture_color(_x+spread, _y+i2-yoff, 0, (i2-yoff)/sH, c_white, _alpha);
			draw_vertex_texture_color(_x+sW+spread, _y+i2-yoff, 1, (i2-yoff)/sH, c_white, _alpha);
		}
	}
	
	draw_primitive_end();
}
#endregion
