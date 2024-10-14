/// @description 

right = 0;
left = 0;
bottom = 0;
top = 0;

alpha = 1;
alphaRate = 0;
alphaRateMultIncr = 1;
alphaRateMultDecr = 1;
alphaNum = -1;
alphaMult = 1;
function Step()
{
	if(alphaNum > 0)
	{
		alpha += alphaRate * alphaRateMultIncr;
		if(alpha >= 1)
		{
			alpha = 1;
			alphaNum *= -1;
		}
	}
	else
	{
		alpha -= alphaRate * alphaRateMultDecr;
		if(alpha <= 0)
		{
			alpha = 0;
			instance_destroy();
		}
	}
}

colorMult = 1;
spread = 1;
width = 1;

surf = surface_create(1,1);
surf2 = surface_create(1,1);
appSurf = surface_create(1,1);
finalSurf = surface_create(1,1);

distSpread = shader_get_uniform(shd_DistortMask,"u_spread");
distWidth = shader_get_uniform(shd_DistortMask,"u_width");

distortStage = shader_get_sampler_index(shd_Distortion,"distortion_texture_page");
distortTexel = shader_get_uniform(shd_Distortion,"texelSize");

function UpdateSurface()
{
	var _width = abs(right-left),
		_height = abs(bottom-top);
	if(_width <= 0 || _height <= 0)
	{
		exit;
	}
	
	if(!surface_exists(surf))
	{
		surf = surface_create(_width,_height);
	}
	else
	{
		surface_resize(surf,_width,_height);
		surface_set_target(surf);
		draw_clear_alpha(make_color_rgb(127,127,255),0);
			
		draw_primitive_begin(pr_trianglefan);
		draw_vertex_color((_width/2),(_height/2),make_color_rgb(127,127,255),1);
		for(var i = 0; i <= 360; i += 5)
		{
			var col = make_color_rgb(127+lengthdir_x(127,i)*colorMult,127-lengthdir_y(127,i)*colorMult,127);
				
			var x1 = (_width/2)+lengthdir_x((_width/2),i),
				y1 = (_height/2)+lengthdir_y((_height/2),i);
			draw_vertex_color(x1,y1,col,1);
		}
		draw_primitive_end();
			
		surface_reset_target();
	}
		
	if(!surface_exists(surf2))
	{
		surf2 = surface_create(_width,_height);
	}
	else if(surface_exists(surf))
	{
		surface_resize(surf2,_width,_height);
		surface_set_target(surf2);
		draw_clear_alpha(make_color_rgb(127,127,255),1);
			
		gpu_set_colorwriteenable(1,1,1,0);
		shader_set(shd_DistortMask);
		shader_set_uniform_f(distSpread,spread);
		shader_set_uniform_f(distWidth,width);
		draw_surface_ext(surf, 0, 0, 1,1,0,c_white,alpha*alphaMult);
		shader_reset();
		gpu_set_colorwriteenable(1,1,1,1);
			
		surface_reset_target();
	}
}

function Draw()
{
	var _width = abs(right-left),
		_height = abs(bottom-top);
	if(_width <= 0 || _height <= 0)
	{
		exit;
	}
	var camX = camera_get_view_x(view_camera[0]),
		camY = camera_get_view_y(view_camera[0]);
	var surfX = (right < left) ? right : left,
		surfY = (bottom < top) ? bottom : top;
	
	if(!surface_exists(appSurf))
	{
		appSurf = surface_create(_width,_height);
	}
	else
	{
		surface_resize(appSurf,_width,_height);
		surface_set_target(appSurf);
	
		gpu_set_blendenable(false);
		draw_surface_ext(application_surface,-(surfX-camX),-(surfY-camY),1,1,0,c_white,1);
		gpu_set_blendenable(true);
	
		surface_reset_target();
	}
	if(!surface_exists(finalSurf))
	{
		finalSurf = surface_create(_width,_height);
	}
	else if(surface_exists(surf2) && surface_exists(appSurf))
	{
		surface_resize(finalSurf,_width,_height);
		surface_set_target(finalSurf);
	
		shader_set(shd_Distortion);

		var tex = surface_get_texture(surf2);

		texture_set_stage(distortStage,tex);
		gpu_set_texfilter_ext(distortStage, false);

		var texel_x = texture_get_texel_width(tex);
		var texel_y = texture_get_texel_height(tex);
		shader_set_uniform_f(distortTexel, texel_x, texel_y);
	
		gpu_set_blendenable(false);
		draw_surface_ext(appSurf,0,0,1,1,0,c_white,1);
		gpu_set_blendenable(true);
	
		shader_reset();
	
		surface_reset_target();
		
		gpu_set_colorwriteenable(1,1,1,0);
		draw_surface_ext(finalSurf, surfX, surfY, 1,1,0,c_white,image_alpha);
		gpu_set_colorwriteenable(1,1,1,1);
	}
}