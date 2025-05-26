/// @description 
event_inherited();

rotation = 0;

instance_destroy(mBlock);
mBlockOffsetX = 0;
mBlockOffsetY = 0;
mBlock = instance_create_layer(x,y,"Collision",obj_PushBall_Mask);
mBlock.ignoredEntity = id;

rotScale = 5;
surfW = sprite_get_width(sprite_index) + 8;
surfH = sprite_get_height(sprite_index) + 8;
surf = surface_create(surfW*rotScale,surfH*rotScale);