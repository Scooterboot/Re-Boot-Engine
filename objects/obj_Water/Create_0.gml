/// -- Movement/Surface --

image_alpha = .45;
x = 0;

/// -- Create surface and redraw it --

Distortion = surface_create(global.resWidth,global.resHeight);

/// -- Everything else.

#region water_redraw
function water_redraw(SurfaceID, RefractID)
{
	surface_set_target(SurfaceID);
	draw_clear_alpha(0,0);

	if (RefractID == 0)
	{
	    /// -- Basic Water

	    for (var xOff = -(sprite_width*2); xOff <= room_width + (sprite_width*2); xOff += sprite_width)
	    {
	        draw_sprite_ext(sprite_index, 0, x+xOff, 0, 1, 1, 0, image_blend, 1);
        
	        for (var yOff = sprite_height; yOff <= room_height - y + sprite_height; yOff += sprite_height)
	        {
	            draw_sprite_ext(sprite_index, 1, x+xOff, yOff, 1, 1, 0, image_blend, 1);
	        }
	    }
	}
	else if (RefractID == 1)
	{
	    // -- Final Render Refraction Surface
    
	    gpu_set_colorwriteenable(1,1,1,0);
	    draw_surface(waterSurfaceRefractMask, (RefractX mod 64) - 32, 0);
    
	    gpu_set_colorwriteenable(0,0,0,1);
	    draw_surface(waterSurfaceRefractGlow, 0, 0);
    
	    gpu_set_colorwriteenable(1,1,1,1);
	}
	else if (RefractID == 2)
	{
	    // -- Refraction Mask Surface
    
	    var refSprt = sprt_WaterRefract;
	    if(object_index == obj_Lava)
	    {
	        refSprt = sprt_LavaRefract;
	    }
	    for (var xOff = -sprite_get_width(refSprt); xOff <= room_width + (sprite_get_width(refSprt)*1.5); xOff += sprite_get_width(refSprt))
	    {
	        draw_sprite_ext(refSprt, 0, xOff, 0, 1, 1, 0, image_blend, 1);
        
	        for (var yOff = sprite_get_height(refSprt); yOff <= room_height - y + sprite_get_height(refSprt); yOff += sprite_get_height(refSprt))
	        {
	            draw_sprite_ext(refSprt, 1, xOff, yOff, 1, 1, 0, image_blend, 1);
	        }
	    }
	}
	else if (RefractID == 3)
	{
	    // -- Refraction Glow Surface
    
	    var refMSprt = sprt_WaterRefractMask;
	    for (var xOff = -(sprite_get_width(refMSprt)*2); xOff <= room_width + (sprite_get_width(refMSprt)*2); xOff += sprite_get_width(refMSprt))
	    {
	        draw_sprite_ext(refMSprt, 0, x+xOff, 0, 1, 1, 0, image_blend, 1);
        
	        for (var yOff = sprite_get_height(refMSprt); yOff <= room_height - y + sprite_get_height(refMSprt); yOff += sprite_get_height(refMSprt))
	        {
	            draw_sprite_ext(refMSprt, 1, x+xOff, yOff, 1, 1, 0, image_blend, 1);
	        }
	    }
	}

	surface_reset_target();
}
#endregion

RefractX = 0;
RefractXSpeed = 0.333;

Time = 0;

waterSurface = surface_create(room_width + 64, room_height - y + 48);
waterSurfaceRefract = surface_create(room_width + 64, room_height - y + 48);
waterSurfaceRefractMask = surface_create(room_width + 128, room_height - y + 48);
waterSurfaceRefractGlow = surface_create(room_width + 64, room_height - y + 48);

water_redraw(waterSurface, 0);
water_redraw(waterSurfaceRefract, 1);
water_redraw(waterSurfaceRefractMask, 2);
water_redraw(waterSurfaceRefractGlow, 3);

// -- Bobbing variables

acc = -.0125/4;     //-.0125/4;
bspd = -.05;         //-.1;
btm = .25;          //.25;

Move = 1;
MoveX = 0.5;

waterColor = merge_color(c_aqua,c_blue,0.85);