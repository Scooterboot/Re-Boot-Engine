/// @description Initialize
event_inherited();

itemName = "xRayVisor";
itemID = 0;

itemHeader = "X-RAY VISOR";
itemDesc = "Select ${hudIcon_4} and hold ${dashButton} to activate." + "\n" + "Reveals destroyable blocks and hidden pathways.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasItem[Item.XRay] = true;
		obj_Player.item[Item.XRay] = true;
	}
}