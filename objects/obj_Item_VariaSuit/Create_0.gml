/// @description Initialize
event_inherited();

itemName = "variaSuit";
itemID = 0;

itemHeader = "VARIA SUIT";
itemDesc = "Traverse heated areas undamaged" + "\n" + "+50% Damage Reduction";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		// todo: suit acquisition animation
		//obj_Player.hasSuit[Suit.Varia] = true;
		//obj_Player.suit[Suit.Varia] = true;
		var sAnim = instance_create_depth(x+8,y-10,10,obj_Item_SuitPickupAnim);
		sAnim.animType = Suit.Varia;
	}
}