/// @description Initialize
event_inherited();

itemName = "grappleBeam";
itemID = 0;

itemHeader = "GRAPPLE BEAM";
//itemDesc = "Select ${hudIcon_3} and press ${shootButton} to fire a Grapple Beam.";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_GrappleBeam)+",0] with ${RadialUIOpen} and ${EquipToggle} and press ${Fire} to launch a Grapple Beam."
			+"\nHook onto and swing from magnetic grapple points.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.GrappleBeam] = true;
	player.item[Item.GrappleBeam] = true;
}