/// @description Delete

instance_destroy(camTile1);
instance_destroy(camTile2);
instance_destroy(solidTile);

for(var i = 0; i < array_length(phase2Blocks); i++)
{
	var blocks = phase2Blocks[i];
	if(instance_exists(blocks))
	{
		blocks.hiddenDestroy = true;
		instance_destroy(blocks);
	}
}
for(var i = 0; i < array_length(remainingBlocks); i++)
{
	var blocks = remainingBlocks[i];
	if(instance_exists(blocks))
	{
		blocks.hiddenDestroy = true;
		instance_destroy(blocks);
	}
}

if(ds_exists(spikes,ds_type_list))
{
	if(spikesNum > 0)
	{
		for(var i = 0; i < spikesNum; i++)
		{
			spikes[| i].hiddenDestroy = true;
			instance_destroy(spikes[| i]);
		}
	}
	ds_list_destroy(spikes);
}

layer_background_blend(layer_background_get_id(layer_get_id("Background")),c_white);