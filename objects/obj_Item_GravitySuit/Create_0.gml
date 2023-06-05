/// @description Initialize
event_inherited();

itemName = "gravitySuit";
itemID = 0;

itemHeader = "GRAVITY SUIT";
itemDesc = "Grants free movement in liquid & stops lava damage." + "\n" + "Halves damage taken.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		var sAnim = instance_create_depth(x+8,y-10,10,obj_Item_SuitPickupAnim);
		sAnim.animType = Suit.Gravity;
	}
}