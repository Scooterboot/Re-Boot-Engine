/// @description Initialize
event_inherited();

itemName = "speedBooster";
itemID = 0;

itemHeader = "SPEED BOOSTER";
itemDesc = "Hold ${dashButton} while moving to build up speed and activate\n" +
"Crouch while active to charge a shine spark";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.SpeedBoost] = true;
		obj_Player.boots[Boots.SpeedBoost] = true;
	}
}