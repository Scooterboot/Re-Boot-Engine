/// -- Draw All Water --

if(!global.gamePaused)// !(oControl.PausedGame)
{
    Time += .0625;
}

/// -- Distort --

if (global.waterDistortion)
{
    draw_set_color(c_white);
	
	if(surface_exists(Distortion))
	{
		var appSurfScale = 1;
		if(global.upscale == 7)
		{
			appSurfScale = 1/obj_Main.screenScale;
		}
		
		surface_resize(Distortion,global.resWidth,global.resHeight);
		surface_set_target(Distortion);
		draw_clear_alpha(c_black,1);
		draw_surface_ext(application_surface,0,0,appSurfScale,appSurfScale,0,c_white,1);
		surface_reset_target();
	}
	else
	{
		Distortion = surface_create(global.resWidth,global.resHeight);
	}
	
    Texture = surface_get_texture(Distortion);
    
    draw_primitive_begin_texture(pr_trianglestrip,Texture);
    
    for(i = 0; i < room_height + 48 - y; i += 6)
    {
        Mult = -min(1.5,i/6);
        Spread = Mult * sin(Time+i/4+y/4);
        
		var vx = camera_get_view_x(view_camera[0]);
		var vy = camera_get_view_y(view_camera[0]);
		
        draw_vertex_texture_color(vx + Spread,floor(y) + i,0,((i+floor(y)-vy)/global.resHeight),c_white,0.5);
        draw_vertex_texture_color(vx + Spread + global.resWidth,floor(y) + i,1,((i+floor(y)-vy)/global.resHeight),c_white,0.5);
    }
    
    draw_primitive_end();
}
else
{
	surface_free(Distortion);
}


/// -- 0: Dark Blue Tint

gpu_set_blendmode(bm_add);

draw_set_alpha(image_alpha/4);
draw_set_color(waterColor);
draw_rectangle(0,y,room_width,room_height,0);
draw_set_color(c_white);
draw_set_alpha(1);

gpu_set_blendmode(bm_normal);

/// -- Surface 1: Basic Water Layer

if (surface_exists(waterSurface))
{
    water_redraw(waterSurface, 0);
    var Texture = surface_get_texture(waterSurface);
    
    gpu_set_blendmode(bm_add); 
    draw_primitive_begin_texture(pr_trianglestrip, Texture);
    draw_set_color(c_white);

    for (var i = 0; i < room_height - y + 48; i += min(max(1,i)*6,32))
    {
        Mult = min(12,i/3);
        Spread = Mult * sin(Time/2 + i/16) / 2.5;
        Alpha = 1;
        if(i > 16)
        {
            Alpha = max(1 - 0.25*((i-16)/min(max(1,i)*6,32)), 0.25);
        }
        
        draw_vertex_texture_color(Spread-32,floor(y+i),0,i/surface_get_height(waterSurface),c_white,image_alpha*Alpha);
        draw_vertex_texture_color(Spread+room_width+32,floor(y+i),1,i/surface_get_height(waterSurface),c_white,image_alpha*Alpha);
    }

    draw_primitive_end();

    gpu_set_blendmode(bm_normal);
}
else
{
    waterSurface = surface_create(room_width + 64, room_height - y + 48);
    water_redraw(waterSurface, 0);
}

/// -- Surface 2: Refraction Layer

if (surface_exists(waterSurfaceRefract))
{
    var Texture = surface_get_texture(waterSurfaceRefract);
    
    gpu_set_blendmode(bm_add); 
    
    draw_primitive_begin_texture(pr_trianglestrip, Texture);
    draw_set_color(c_white);
    
    for (var i = 0; i < room_height - y + 48; i += min(max(1,i)*6,32))
    {
        Mult = min(12,i/3);
        Spread = Mult * sin(Time/2 + i/16) / 2.5;
        Alpha = 1;
        if(i > 16)
        {
            Alpha = max(1 - 0.25*((i-16)/min(max(1,i)*6,32)), 0.25);
        }
        
        draw_vertex_texture_color(Spread-32,floor(y+i),0,i/surface_get_height(waterSurfaceRefract), c_white, Alpha);
        draw_vertex_texture_color(Spread+room_width+32,floor(y+i),1,i/surface_get_height(waterSurfaceRefract), c_white, Alpha);
    }
    
    draw_primitive_end();
    
    gpu_set_blendmode(bm_normal);
}
else
{
    waterSurfaceRefract = surface_create(room_width + 64, room_height - y + 48);
}

/// -- Refraction Surface failsafes

if !(surface_exists(waterSurfaceRefractMask))
{
    waterSurfaceRefractMask = surface_create(room_width + 128, room_height - y + 48);
    water_redraw(waterSurfaceRefractMask, 2);
}

if !(surface_exists(waterSurfaceRefractGlow))
{
    waterSurfaceRefractGlow = surface_create(room_width + 64, room_height - y + 48);
    //water_redraw(waterSurfaceRefractGlow, 3);
}
water_redraw(waterSurfaceRefractGlow, 3);

/// -- Refraction Layer always keeps updating

water_redraw(waterSurfaceRefract, 1);
RefractX += RefractXSpeed;