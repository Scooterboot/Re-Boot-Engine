/// @description Initialize
event_inherited();

itemName = "speedBooster";
itemID = 0;

itemHeader = "SPEED BOOSTER";
//itemDesc = "Hold ${sprintButton} while moving to run extremely fast.\n" +
//"Crouch during Speed Boost to charge a Shine Spark.";
itemDesc = "Hold ${Sprint} while moving to run extremely fast.\n" +
"Crouch during Speed Boost to charge a Shine Spark.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.SpeedBooster] = true;
	player.item[Item.SpeedBooster] = true;
}