/// @description 

if(sprite_index == sprt_WaterSplash || watery)
{
	gpu_set_blendmode(bm_add);
	if(watery)
	{
		image_alpha = 0.7;
	}
	if(sprite_index == sprt_WaterSplash)
	{
		image_alpha = 0.5;
	}
}

var spInd = sprite_index;
var yscale = image_yscale;
if(liquid.liquidType == LiquidType.Lava)
{
	spInd = scr_ConvertToLavaSprite(spInd);
	yscale = image_yscale*0.75;
	if(watery)
	{
		image_blend = make_color_rgb(255,255,80);
	}
}
else if(liquid.liquidType == LiquidType.Acid)
{
	spInd = scr_ConvertToAcidSprite(spInd);
}

draw_sprite_ext(spInd, image_index, scr_round(x), scr_round(y), image_xscale, yscale, image_angle, image_blend, image_alpha);

if(splash)
{
    draw_sprite_ext(spInd, image_index, scr_round(x), scr_round(y), image_xscale*1.2, -yscale/(1.6 + ((sprite_index == sprt_WaterBoil) * 4)), image_angle, image_blend, image_alpha/1.2);
}

gpu_set_blendmode(bm_normal);