/// @description Insert description here
// You can write your code in this editor

if(state == 1)
{
	instance_destroy(camTile1);
	instance_destroy(camTile2);
	instance_destroy(solidTile);
	
	counter[0]++;
	if(counter[0] > 20 && counter[1] < array_length(phase2Blocks))
	{
		instance_destroy(phase2Blocks[counter[1]]);
		counter[1]++;
		
		counter[0] = 10;
	}
	
	if(counter[1] >= array_length(phase2Blocks))
	{
		state = 2;
		counter[0] = 0;
		counter[1] = 0;
	}
}

if(state == 3)
{
	for(var i = 0; i < array_length(remainingBlocks); i++)
	{
		instance_destroy(remainingBlocks[i]);
	}

	//if(spikesNum > 0)
	//{
	//	for(var i = 0; i < spikesNum; i++)
	//	{
	//		instance_destroy(spikes[| i]);
	//	}
	//}
	//ds_list_destroy(spikes);
	counter[0]++;
	if(counter[0] > 30 && counter[1] < ds_list_size(spikes))
	{
		instance_destroy(spikes[| counter[1]]);
		counter[1]++;
		
		counter[0] = 0;
	}
	
	if(counter[1] >= ds_list_size(spikes))
	{
		state = 4;
		counter[0] = 0;
		counter[1] = 0;
		ds_list_destroy(spikes);
	}
}
if(state == 4)
{
	instance_destroy();
}

if(state >= 1)
{
	bgAlpha = min(bgAlpha+0.05,1);
}
layer_background_blend(layer_background_get_id(layer_get_id("Background")),c_white*bgAlpha);