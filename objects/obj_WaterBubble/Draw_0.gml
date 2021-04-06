/// -- Draw

FinalAlpha = (1+Alpha)/2*AlphaMult;

if (CanSpread && !Delete)
{
	FinalAlpha = Alpha * .8 * FadeIn;
	Scale = Breathed;
}
else
{
	FinalAlpha = Alpha * .9 * FadeIn;
	Scale = 1;
}

Spr = sprite_index;

if (instance_exists(obj_Lava))
{
	//Spr = asset_get_index(sprite_get_name(Spr) + "Lava");
	//Spr = scr_ConvertToLavaSprite(sprite_index);
}

gpu_set_blendmode(bm_add);
draw_sprite_ext(Spr, Index,x,y,Scale,Scale,0,image_blend,FinalAlpha);
gpu_set_blendmode(bm_normal);