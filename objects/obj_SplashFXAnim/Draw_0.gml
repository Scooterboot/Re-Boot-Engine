/// -- Draw --

if (sprite_index == sprt_WaterSplash or Watery)
{
   gpu_set_blendmode(bm_add);
    
    if (Watery)
    {
        image_alpha = .7;
    }
    
    if (sprite_index == sprt_WaterSplash)
    {
        image_alpha = .5;
    }
}

Spr = sprite_index;

if (Watery && instance_exists(obj_Lava))
{
    //Spr = asset_get_index(sprite_get_name(Spr) + "Lava");
    //Spr = scr_ConvertToLavaSprite(sprite_index);
    image_blend = make_color_rgb(255,255,80);
}

var yscale = image_yscale;
if(instance_exists(obj_Lava))
{
    yscale = image_yscale*0.75;
}

draw_sprite_ext(Spr, image_index, floor(x), floor(y), image_xscale, yscale, image_angle, image_blend, image_alpha);

if (Splash)
{
    draw_sprite_ext(Spr, image_index, floor(x), floor(y), image_xscale*1.2, -yscale/(1.6 + ((sprite_index == sprt_WaterBoil) * 4)), image_angle, image_blend, image_alpha/1.2);
    //depth = 41;//-261;
}    

if (sprite_index == sprt_WaterSplash or Splash or Watery)
{
    gpu_set_blendmode(bm_normal);
}