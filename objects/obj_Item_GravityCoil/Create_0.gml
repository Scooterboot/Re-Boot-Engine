/// @description Initialize
event_inherited();

itemName = "gravityCoil";
//itemID = 0;

itemHeader = "GRAVITY COIL";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_GravGrapple)+",0] with ${RadialUIOpen} and ${EquipToggle} and press ${Fire} to launch a Gravity Coil."
			+"\nAttaches to any surface.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.GravGrapple] = true;
	player.item[Item.GravGrapple] = true;
}