/// @description Initialize
event_inherited();

itemName = "speedBooster";
itemID = 0;

itemHeader = "SPEED BOOSTER";
itemDesc = "Hold ${dashButton} while moving to run extremely fast.\n" +
"Crouch during Speed Boost to charge a Shine Spark.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.SpeedBoost] = true;
		obj_Player.boots[Boots.SpeedBoost] = true;
	}
}