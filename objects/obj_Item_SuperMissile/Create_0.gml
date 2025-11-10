/// @description Initialize
event_inherited();

itemName = "superMissileTank";
itemID = 0;

sMissileAmount = 5;

itemHeader = "SUPER MISSILE";
//itemDesc = "Select it and press [Shoot]";
//itemDesc = "Select ${hudIcon_1} and press ${shootButton} to fire a Super Missile.";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_SuperMissile)+",0] with ${RadialUIOpen} and ${WeapToggle} and press ${Fire} to fire a Super Missile.";
expanHeader = "SUPER MISSILE EXPANSION";
expanDesc = "+"+string(sMissileAmount)+" Super Missile Capacity";

function CollectItem(player)
{
	isExpansion = (player.hasItem[Item.SuperMissile]);
	player.hasItem[Item.SuperMissile] = true;
	player.item[Item.SuperMissile] = true;
	player.superMissileMax += sMissileAmount;
	player.superMissileStat += sMissileAmount;
}