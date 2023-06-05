/// @description Initialize

state = 0;
// 0 = do nothing
// 1 = second phase start
// 2 = second phase end
// 3 = death start
// 4 = death end
counter = array_create(2,0);

camTile1 = collision_rectangle(0,256,16,256+16,obj_CamTile,false,true);
camTile2 = collision_rectangle(320,272,320+16,272+16,obj_CamTile_NonWScreen,false,true);

//solidTile = collision_rectangle(288,320,288+16,320+16,obj_Tile,false,true);

phase2Blocks[0] = collision_rectangle(320,288,320+16,288+16,obj_NPCBreakable,false,true);
phase2Blocks[1] = collision_rectangle(208,288,208+16,288+16,obj_NPCBreakable,false,true);
phase2Blocks[2] = collision_rectangle(96,288,96+16,288+16,obj_NPCBreakable,false,true);

remainingBlocks[0] = collision_rectangle(160,288,160+16,288+16,obj_NPCBreakable,false,true);
remainingBlocks[1] = collision_rectangle(272,288,272+16,288+16,obj_NPCBreakable,false,true);

spikes = ds_list_create();
for(var i = 112; i < 464; i += 32)
{
	ds_list_add(spikes, collision_rectangle(i,432,i+16,448,obj_Spikes,false,true));
}

bgAlpha = 0;
layer_background_blend(layer_background_get_id(layer_get_id("Background")),c_black);