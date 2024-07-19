/// @description Initialize
event_inherited();

itemName = "gravitySuit";
itemID = 0;

itemHeader = "GRAVITY SUIT";
itemDesc = "Grants free movement in liquid & stops lava damage." + "\n" + "Halves damage taken.";

isMajorItem = true;

function CollectItem(player)
{
	var sAnim = instance_create_depth(x+8,y-10,10,obj_Item_SuitPickupAnim);
	sAnim.player = player;
	sAnim.animType = Suit.Gravity;
}