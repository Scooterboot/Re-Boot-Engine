/// @description 
event_inherited();

if(array_length(mBlocks) > 0)
{
    for(var i = 0; i < array_length(mBlocks); i++)
	{
		instance_destroy(mBlocks[i]);
	}
}