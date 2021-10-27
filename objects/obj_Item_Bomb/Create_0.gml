/// @description Initialize
event_inherited();

itemName = "ballBomb";
itemID = 0;

itemHeader = "BOMB";
itemDesc = "[sprt_Text_MiniPlayer] [sprt_Text_Arrow] [sprt_Text_MiniMorph] and press ${shootButton} to set";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.Bomb] = true;
		obj_Player.misc[Misc.Bomb] = true;
	}
}