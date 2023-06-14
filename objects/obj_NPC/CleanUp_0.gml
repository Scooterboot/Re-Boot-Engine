/// @description Remove platform
event_inherited();

if(instance_exists(freezePlatform))
{
    instance_destroy(freezePlatform);
}

ds_list_destroy(block_list);