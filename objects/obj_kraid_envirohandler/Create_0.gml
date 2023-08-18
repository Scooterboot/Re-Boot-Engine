/// @description Initialize

state = 0;
// 0 = do nothing
// 1 = spawn start
// 2 = spawn end
// 3 = second phase start
// 4 = second phase end
// 5 = death start
// 6 = death end
counter = array_create(2,0);

camTile1 = collision_rectangle(0,256,16,256+16,obj_CamTile,false,true);
camTile2 = collision_rectangle(320,272,320+16,272+16,obj_CamTile_NonWScreen,false,true);

phase2Blocks = ds_list_create();
collision_rectangle_list(65,289,142,302,obj_NPCBreakable,false,true,phase2Blocks,false);
collision_rectangle_list(193,289,254,302,obj_NPCBreakable,false,true,phase2Blocks,false);
collision_rectangle_list(305,289,510,302,obj_NPCBreakable,false,true,phase2Blocks,false);

remainingBlocks[0] = collision_rectangle(160,288,160+16,288+16,obj_NPCBreakable,false,true);
remainingBlocks[1] = collision_rectangle(272,288,272+16,288+16,obj_NPCBreakable,false,true);

spikes = ds_list_create();
for(var i = 112; i < 464; i += 32)
{
	ds_list_add(spikes, collision_rectangle(i,432,i+16,448,obj_Spikes,false,true));
}

bgAlpha = 0;
layer_background_blend(layer_background_get_id(layer_get_id("Background")),c_black);


partAreaX1 = 144;
partAreaY1 = 416;
partAreaX2 = 351;
partAreaY2 = 447;