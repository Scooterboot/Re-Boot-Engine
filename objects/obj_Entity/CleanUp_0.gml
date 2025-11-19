/// @description 

ds_list_destroy(blockList);
ds_list_destroy(breakList);
ds_list_destroy(doorList);
ds_list_destroy(switchList);

for(var i = 0; i < array_length(lifeBoxes); i++)
{
	instance_destroy(lifeBoxes[i]);
}
for(var i = 0; i < array_length(dmgBoxes); i++)
{
	instance_destroy(dmgBoxes[i]);
}
ds_list_destroy(iFrameCounters);