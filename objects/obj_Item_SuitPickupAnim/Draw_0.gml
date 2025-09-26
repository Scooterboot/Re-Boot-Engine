/// @description Anim

var cw = global.wideResWidth,
	ch = global.resHeight;

if(!surface_exists(surf))
{
	surf = surface_create(cw*2,ch*2);
}
else
{
	surface_set_target(surf);
	
	draw_clear_alpha(c_black,0);
	
	var sw = surface_get_width(surf),
		sh = surface_get_height(surf);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_ellipse(sw/2-animW,sh/2-animH-8,sw/2+animW,sh/2+animH-8,false);
	
	draw_sprite_ext(sprt_Player_StandSuitAnimZS,0,sw/2,sh/2,1,1,0,c_white,1);
	
	surface_reset_target();
	
	
	if(!global.GamePaused())
	{
		if(animCounter < animCounterMax)
		{
			animH = min((animH+0.25)*1.1,ch*1.5);
			if(animH < ch*1.5)
			{
				animW = min(animW+0.25,2);
			}
			else
			{
				animW = min((animW+2)*1.1,cw*2);
			}
		}
		else
		{
			animH = max(animH*0.9,2);
			if(animH <= 2)
			{
				animW = max((animW-1)*0.9,0);
			}
			else
			{
				animW = max(animW*0.96,0);
			}
		}
	}
	
	var col = c_orange;
	if(animType == Item.GravitySuit)
	{
		col = c_fuchsia;
	}
	draw_set_color(col);
	draw_set_alpha(0.5);
	draw_ellipse(x-animW,y-animH-8,x+animW,y+animH-8,false);
	
	gpu_set_blendmode(bm_add);
	draw_ellipse_color(x-animW,y-animH-8,x+animW,y+animH-8,col,c_black,false);
	gpu_set_blendmode(bm_normal);
	
	var sAlpha = 0;
	if(animCounter < animCounterMax)
	{
		var animC = animCounter-animCounterMax/2;
		sAlpha = max(animC/(animCounterMax/2),0);
	}
	else
	{
		var animC = animCounter-animCounterMax;
		sAlpha = 1-min(animC/(animCounterMax/4),1);
	}
	
	draw_surface_ext(surf,x-sw/2,y-sh/2,1,1,0,c_white,sAlpha);
}