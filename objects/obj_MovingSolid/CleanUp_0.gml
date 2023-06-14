/// @description 
event_inherited();

for(var i = 0; i < array_length(mBlocks); i++)
{
	if(instance_exists(mBlocks[i]))
	{
		instance_destroy(mBlocks[i]);
	}
}