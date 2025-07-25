/// @description 
event_inherited();

rotation = 0;

instance_destroy(mBlocks[0]);
mBlockOffset[0] = new Vector2();
mBlocks[0] = instance_create_layer(x,y,"Collision",obj_PushBall_Mask);
mBlocks[0].ignoredEntity = id;

rotScale = 5;
surfW = sprite_get_width(sprite_index) + 8;
surfH = sprite_get_height(sprite_index) + 8;
surf = surface_create(surfW*rotScale,surfH*rotScale);