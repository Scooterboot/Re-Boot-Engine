/// @description Remove platform
event_inherited();

if(instance_exists(platform))
{
    instance_destroy(platform);
}