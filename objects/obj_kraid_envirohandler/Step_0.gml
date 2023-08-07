/// @description Insert description here
// You can write your code in this editor

if(state > 0)
{
	instance_destroy(camTile1);
	instance_destroy(camTile2);
}

if(state == 1)
{
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
if(state == 2)
{
	bgAlpha = min(bgAlpha+0.025,1);
}

if(state == 3)
{
	for(var i = 0; i < array_length(phase2Blocks); i++)
	{
		instance_destroy(phase2Blocks[i]);
	}
	for(var i = 0; i < array_length(remainingBlocks); i++)
	{
		instance_destroy(remainingBlocks[i]);
	}

	counter[0]++;
	if(counter[0] > 10 && ds_list_size(spikes) > 0)
	{
		instance_destroy(spikes[| 0]);
		ds_list_delete(spikes, 0);
		
		counter[0] = 0;
	}
	
	counter[1]++;
	if(counter[1] >= 320 && ds_list_size(spikes) <= 0)
	{
		ds_list_destroy(spikes);
		state = 4;
		counter[0] = 0;
		counter[1] = 0;
	}
	
	bgAlpha = max(bgAlpha-0.1,0);
}
if(state == 4)
{
	bgAlpha = min(bgAlpha+0.025,1);
	if(bgAlpha >= 1)
	{
		instance_destroy();
	}
}

var bgCol = make_color_rgb(255*bgAlpha,255*bgAlpha,255*bgAlpha);
layer_background_blend(layer_background_get_id(layer_get_id("Background")),bgCol);