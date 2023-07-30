/// @description Initialize

liquid = noone;

image_speed = 0;

initIndex = false;
newIndex = 0;
prevIndex = 0;

animSpeed = 0;

velX = 0;
velY = 0;
fVelX = 0;

splash = false;
watery = true;

waterSplashMoveX = array(3,3,3,4,4,3,3,3,3,1,1,0,0);
ogScaleX = image_xscale;

mask_index = sprite_index;
ogRight = abs(bbox_right-x);
ogLeft = abs(x-bbox_left);