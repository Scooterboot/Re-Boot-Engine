/// @description Remove platform
if(instance_exists(freezePlatform))
{
    with(freezePlatform)
    {
        instance_destroy();
    }
}
lhc_cleanup();
