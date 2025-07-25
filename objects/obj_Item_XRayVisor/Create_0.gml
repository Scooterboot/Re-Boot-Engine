/// @description Initialize
event_inherited();

itemName = "xRayVisor";
itemID = 0;

itemHeader = "X-RAY VISOR";
itemDesc = "Select ${hudIcon_4} and hold ${sprintButton} to activate." + "\n" + "Reveals destroyable blocks and hidden pathways.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.XRayVisor] = true;
	player.item[Item.XRayVisor] = true;
}