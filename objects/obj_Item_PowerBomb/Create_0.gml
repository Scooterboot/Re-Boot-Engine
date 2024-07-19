/// @description Initialize
event_inherited();

itemName = "powerBombTank";
itemID = 0;

pBombAmount = 5;

itemHeader = "POWER BOMB";
//itemDesc = "While Morphed, select it and press [Shoot]";
itemDesc = "Select ${hudIcon_2} and press ${shootButton} to set during [sprt_Text_MiniMorph]";
expanHeader = "POWER BOMB EXPANSION";
expanDesc = "+"+string(pBombAmount)+" Power Bomb Capacity";

function CollectItem(player)
{
	isExpansion = (player.hasItem[Item.PBomb]);
	player.hasItem[Item.PBomb] = true;
	player.item[Item.PBomb] = true;
	player.powerBombMax += pBombAmount;
	player.powerBombStat += pBombAmount;
}