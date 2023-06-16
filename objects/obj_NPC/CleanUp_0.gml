/// @description Remove platform
event_inherited();

if(instance_exists(freezePlatform))
{
    instance_destroy(freezePlatform);
}