/// @description Initialize
event_inherited();

itemName = "powerGrip";
itemID = 0;

itemHeader = "POWER GRIP";
itemDesc = "Grab and hang from ledges and corners.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.PowerGrip] = true;
		obj_Player.misc[Misc.PowerGrip] = true;
	}
}