/// @description Initialize
event_inherited();

itemName = "variaSuit";
itemID = 0;

itemHeader = "VARIA SUIT";
itemDesc = "Traverse heated areas undamaged" + "\n" + "Halves damage taken";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		var sAnim = instance_create_depth(x+8,y-10,10,obj_Item_SuitPickupAnim);
		sAnim.animType = Suit.Varia;
	}
}