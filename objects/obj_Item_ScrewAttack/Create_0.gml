/// @description Initialize
event_inherited();

itemName = "screwAttack";
itemID = 0;

itemHeader = "SCREW ATTACK";
itemDesc = "Damage enemies during spin jump.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.ScrewAttack] = true;
	player.item[Item.ScrewAttack] = true;
}