/// @description Initialize
event_inherited();

liquidType = LiquidType.Lava;

alpha = 0.75;

moveY = true;

imgIndex = 0;
lavaColor = merge_colour(c_orange,c_red,0.85);
lavaColorAlpha = 0.375;//0.25;

gradCol = make_color_rgb(225,32,0);
gradAlpha = 0.75;

ambSnd[0] = amb_LavaAmbiance_0;
ambSnd[1] = amb_LavaAmbiance_1;
ambSnd[2] = amb_LavaAmbiance_2;

lavaSurface = surface_create(SurfWidth2(),SurfHeight2());

extraDistH = 32;
finalSurface = surface_create(SurfWidth(), SurfHeight() + extraDistH);

function LavaSurface()
{
	if(surface_exists(lavaSurface))
	{
		var pos = SurfPos();
		
		surface_resize(lavaSurface,SurfWidth2(),SurfHeight2());
		surface_set_target(lavaSurface);
		draw_clear_alpha(c_black,0);
		
		draw_sprite_ext(sprite_index,1+scr_floor(imgIndex),(x-pos.X)+posX-spriteW/2,y-pos.Y,image_xscale+2,image_yscale+1,0,c_white,1);
		
		surface_reset_target();
	}
	else
	{
		lavaSurface = surface_create(SurfWidth2(),SurfHeight2());
		surface_set_target(lavaSurface);
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
	for(var i = 0; i <= scaledH()+spriteH; i += min(max(i,12),32))
	{
		if(i >= yoff-32 && i <= yoff+sH+32)
		{
			var mult = min(12,i);
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
