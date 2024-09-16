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

surf = noone;
distSpread = shader_get_uniform(shd_DistortMask,"u_spread");
distWidth = shader_get_uniform(shd_DistortMask,"u_width");
function UpdateSurface()
{
	var _width = right-left,
		_height = bottom-top;
	if(_width > 0 && _width > 0)
	{
		if(surface_exists(surf))
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
		else
		{
			surf = surface_create(_width,_height);
		}
	}
}

function DrawDistort(_xoff = 0, _yoff = 0)
{
	var _width = right-left,
		_height = bottom-top;
	if(visible && _width > 0 && _width > 0 && surface_exists(surf))
	{
		shader_set(shd_DistortMask);
		shader_set_uniform_f(distSpread,spread);
		shader_set_uniform_f(distWidth,width);
		draw_surface_ext(surf, left+_xoff, top+_yoff, 1,1,0,c_white,alpha*alphaMult);
		shader_reset();
	}
}