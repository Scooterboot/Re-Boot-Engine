/// @description 
event_inherited();

for(var i = 0; i < array_length(mBlocks); i++)
{
	instance_destroy(mBlocks[i]);
}