/// @description Initialize
event_inherited();

itemName = "screwAttack";
itemID = 0;

itemHeader = "SCREW ATTACK";
itemDesc = "Damage enemies during spin jump.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasMisc[Misc.ScrewAttack] = true;
	player.misc[Misc.ScrewAttack] = true;
}