/// @description Initialize
event_inherited();

itemName = "powerBombTank";
itemID = 0;

pBombAmount = 5;

itemHeader = "POWER BOMB";
//itemDesc = "While Morphed, select it and press [Shoot]";
//itemDesc = "Select ${hudIcon_2} and press ${shootButton} to set during [sprt_Text_MiniMorph]";
itemDesc = "Select ["+sprite_get_name(sprt_HUD_Icon_PowerBomb)+",0] with ${RadialUIOpen} and ${WeapToggle} and press ${Fire} to set during [sprt_Text_MiniMorph]";
expanHeader = "POWER BOMB EXPANSION";
expanDesc = "+"+string(pBombAmount)+" Power Bomb Capacity";

function CollectItem(player)
{
	isExpansion = (player.hasItem[Item.PowerBomb]);
	player.hasItem[Item.PowerBomb] = true;
	player.item[Item.PowerBomb] = true;
	player.powerBombMax += pBombAmount;
	player.powerBombStat += pBombAmount;
}