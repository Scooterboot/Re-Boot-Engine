/// @description Initialize
event_inherited();

itemName = "grappleBeam";
itemID = 0;

itemHeader = "GRAPPLE BEAM";
itemDesc = "Select ${hudIcon_3} and press ${shootButton} to fire";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasItem[Item.Grapple] = true;
		obj_Player.item[Item.Grapple] = true;
	}
}