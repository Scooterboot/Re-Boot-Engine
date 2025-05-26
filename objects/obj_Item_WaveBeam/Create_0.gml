/// @description Initialize
event_inherited();

itemName = "waveBeam";
itemID = 0;

itemHeader = "WAVE BEAM";
itemDesc = "Your beam now passes through walls.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBeam[Beam.Wave] = true;
	player.beam[Beam.Wave] = true;
}