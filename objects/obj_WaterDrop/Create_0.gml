// -- Mask/Sprite --

//init_mask();
//change_mask(-1,-1,1,1,0,"");
water_init(1);

xVel = 0;
yVel = 0;
Gravity = .15;
Dead = 0;

image_alpha = .6;
image_xscale = choose(.7,.8,.9);

if (instance_exists(obj_Lava))
{
    sprite_index = sprt_LavaDrop;
    Gravity = .18;
    image_alpha = .9;
}

image_yscale = image_xscale;

image_index = irandom(image_number);
image_speed = 0;