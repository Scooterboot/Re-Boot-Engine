/// @description 

if(instance_exists(creator) && creator.object_index == obj_Player)
{
	if(fired <= 0 && firedFrame <= 0)
	{
		firedX = creator.shootPosX;
		firedY = creator.shootPosY;
	}
	firedX += creator.position.X-creator.oldPosition.X;
	firedY += creator.position.Y-creator.oldPosition.Y;
}