/// @description Initialize
event_inherited();

itemName = "screwAttack";
itemID = 0;

itemHeader = "SCREW ATTACK";
itemDesc = "Damage enemies during spin jump.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.ScrewAttack] = true;
		obj_Player.misc[Misc.ScrewAttack] = true;
	}
}