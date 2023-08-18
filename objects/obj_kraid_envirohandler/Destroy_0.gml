/// @description Delete

instance_destroy(camTile1);
instance_destroy(camTile2);

for(var i = 0; i < ds_list_size(phase2Blocks); i++)
{
	var blocks = phase2Blocks[| i];
	if(instance_exists(blocks))
	{
		blocks.hiddenDestroy = true;
		instance_destroy(blocks);
	}
}
ds_list_destroy(phase2Blocks);

for(var i = 0; i < array_length(remainingBlocks); i++)
{
	var blocks = remainingBlocks[i];
	if(instance_exists(blocks))
	{
		blocks.hiddenDestroy = true;
		instance_destroy(blocks);
	}
}

for(var i = 0; i < ds_list_size(spikes); i++)
{
	var spik = spikes[| i];
	if(instance_exists(spik))
	{
		spik.hiddenDestroy = true;
		instance_destroy(spikes[| i]);
	}
}
ds_list_destroy(spikes);

layer_background_blend(layer_background_get_id(layer_get_id("Background")),c_white);