/// @description Initialize
event_inherited();

itemName = "boostBall";
itemID = 0;

itemHeader = "BOOST BALL";
itemDesc = "During [sprt_Text_MiniMorph], hold ${dashButton} to charge"+"\n"+"and release to boost.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.Boost] = true;
		obj_Player.misc[Misc.Boost] = true;
	}
}