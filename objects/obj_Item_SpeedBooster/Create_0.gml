/// @description Initialize
event_inherited();

itemName = "speedBooster";
itemID = 0;

itemHeader = "SPEED BOOSTER";
itemDesc = "Hold ${sprintButton} while moving to run extremely fast.\n" +
"Crouch during Speed Boost to charge a Shine Spark.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBoots[Boots.SpeedBoost] = true;
	player.boots[Boots.SpeedBoost] = true;
}