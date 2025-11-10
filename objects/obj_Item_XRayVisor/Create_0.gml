/// @description Initialize
event_inherited();

itemName = "xRayVisor";
itemID = 0;

itemHeader = "X-RAY VISOR";
//itemDesc = "Select ${hudIcon_4} and hold ${sprintButton} to activate." + "\n" + "Reveals destroyable blocks and hidden pathways.";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_XRayVisor)+",0] with ${VisorCycle} and press ${VisorToggle} to activate."
			+"\nReveals destroyable blocks and hidden pathways.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.XRayVisor] = true;
	player.item[Item.XRayVisor] = true;
}