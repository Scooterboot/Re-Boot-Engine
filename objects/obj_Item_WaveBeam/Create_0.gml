/// @description Initialize
event_inherited();

itemName = "waveBeam";
itemID = 0;

itemHeader = "WAVE BEAM";
itemDesc = "Your beam now passes through walls.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.WaveBeam] = true;
	player.item[Item.WaveBeam] = true;
}