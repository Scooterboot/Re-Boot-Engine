/// @description Initialize
event_inherited();

itemName = "scanVisor";
itemID = 0;

itemHeader = "SCAN VISOR";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_ScanVisor)+",0] with ${VisorCycle} and press ${VisorToggle} to activate."
			+"\nPress ${VisorUse} to scan objects and creatures.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.ScanVisor] = true;
	player.item[Item.ScanVisor] = true;
}