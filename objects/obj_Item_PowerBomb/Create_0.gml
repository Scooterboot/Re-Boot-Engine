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

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		isExpansion = (obj_Player.hasItem[Item.PBomb]);
		obj_Player.hasItem[Item.PBomb] = true;
		obj_Player.item[Item.PBomb] = true;
		obj_Player.powerBombMax += pBombAmount;
		obj_Player.powerBombStat += pBombAmount;
	}
}