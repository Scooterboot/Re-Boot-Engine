/// @description Initialize
event_inherited();

itemName = "morphBall";
itemID = 0;

itemHeader = "MORPH BALL";
itemDesc = "Press ${controlPad} down twice to morph into a ball.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.Morph] = true;
		obj_Player.misc[Misc.Morph] = true;
	}
}