
if(!instance_exists(creatorUI) || !instance_exists(page) || (containerEle != noone && !instance_exists(containerEle)))
{
	instance_destroy();
	exit;
}
