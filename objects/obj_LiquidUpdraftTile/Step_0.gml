/// @description 

if(global.gamePaused)
{
	exit;
}

var player = instance_place(x,y,obj_Player);
if(instance_exists(player))
{
	if(player.liquidState > 0)
	{
		var moveSpeed = player.fGrav*2;
		if(player.velY <= -player.fallSpeedMax)
		{
			moveSpeed = player.fGrav;
		}
		player.velY -= moveSpeed;
	}
	else if(!player.grounded)
	{
		var moveSpeed = player.fGrav*0.75;
		player.velY -= moveSpeed;
	}
}

var liquid = instance_place(x,y,obj_Liquid);
if(instance_exists(liquid))
{
	for(var i = bbox_left; i < bbox_right; i += 2)
	{
		for(var j = bbox_top; j < bbox_bottom; j += 2)
		{
			if(irandom(1500) == 0)
			{
				var bub = liquid.CreateBubble(i,j, 0,-10);
				bub.kill = true;
				bub.canSpread = false;
			}
		}
	}
}