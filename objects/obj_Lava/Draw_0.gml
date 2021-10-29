/// @description Graphics

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

if !(global.gamePaused)
{
	Time += .0625;
	Index += .2;
}

/// -- Distort --

if (global.waterDistortion)// && oControl.DrawDistortion && !instance_exists(oHeat))
{
    /*if (view_current == 0)
    {
        if !surface_exists(Distortion)
        {
            Distortion = surface_create(surface_get_width(application_surface),surface_get_height(application_surface));
            surface_copy(Distortion,0,0,application_surface);
        }
        else
        {
            surface_copy(Distortion,0,0,application_surface);
        }
    }
    
    if surface_exists(Distortion)
    {
        Texture = surface_get_texture(Distortion);
        
        draw_primitive_begin_texture(pr_trianglestrip,Texture);
        draw_set_color(c_white);
        
        for (var i = 0; i < room_height + 48 - y; i += 6)
        {
            var Mult = -min(1.5,i/6);
            var Spread = Mult * sin(Time+i/4+y/4);
            
            draw_vertex_texture_colour(xx + Spread,floor(y) + i,0,((i+floor(y)-yy)/hh),c_white,0.5);
            draw_vertex_texture_colour(xx + Spread + ww,floor(y) + i,1,((i+floor(y)-yy)/hh),c_white,0.5);
        }
        
        draw_primitive_end();
    }*/
	if(!surface_exists(Distortion))
	{
		Distortion = surface_create(global.resWidth,global.resHeight);
	}
	else
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
		
		var Texture = surface_get_texture(Distortion);
        
        draw_primitive_begin_texture(pr_trianglestrip,Texture);
        draw_set_color(c_white);
        
        for (var i = 0; i < room_height + 48 - y; i += 6)
        {
            var Mult = -min(1.5,i/6);
            var Spread = Mult * sin(Time+i/4+y/4);
            
            draw_vertex_texture_colour(xx + Spread,floor(y) + i,0,((i+floor(y)-yy)/hh),c_white,0.5);
            draw_vertex_texture_colour(xx + Spread + ww,floor(y) + i,1,((i+floor(y)-yy)/hh),c_white,0.5);
        }
        
        draw_primitive_end();
	}
}


/// -- 0: Fill Screen

gpu_set_blendmode(Mode);

for(var c = -32 + floor(xx/32) * 32; c < floor(xx/32) * 32 + ww + 96; c += 32)
{
    draw_sprite_ext(sprite_index,Index,c+x,floor(y),1,1,image_angle,image_blend,image_alpha);
}

draw_set_color(make_color_rgb(248,104,48));
draw_set_alpha(image_alpha);

draw_rectangle(-16,floor(y)+32,room_width+16,room_height+96,0);

draw_set_color(16777215);
draw_set_alpha(1);
gpu_set_blendmode(bm_normal);