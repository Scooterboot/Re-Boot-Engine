// -- Mask/Sprite --

liquidType = LiquidType.Water;

velX = 0;
velY = 0;
grav = 0.15;
kill = false;

image_alpha = 0.6;
image_xscale = choose(0.7, 0.8, 0.9);

init = false;

image_yscale = image_xscale;

image_index = irandom(image_number);
image_speed = 0;

lhc_activate();
solids[0] = "ISolid";
solids[1] = "IMovingSolid";