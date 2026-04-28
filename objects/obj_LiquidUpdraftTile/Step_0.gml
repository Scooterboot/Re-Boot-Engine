/// @description 

if(global.GamePaused() || !scr_WithinCamRange())
{
	exit;
}

var player = instance_place(x,y,obj_Player);
if(instance_exists(player))
{
	if(player.liquidState == LiquidState.Liquid || player.liquidState == LiquidState.DmgLiquid)
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
		if(player.velY < 0 && player.jumping)
		{
			moveSpeed = player.fGrav;
		}
		player.velY -= moveSpeed;
	}
}

var liquid = instance_place(x,y,obj_Liquid);
if(instance_exists(liquid))
{
	for(var i = bbox_left; i < bbox_right; i += 16)
	{
		for(var j = bbox_top; j < bbox_bottom; j += 16)
		{
			if(irandom(30) == 0)
			{
				var bub = liquid.CreateBubble(i+2*irandom(7),j+2*irandom(7), 0,-10);
				bub.kill = true;
				bub.canSpread = false;
			}
		}
	}
}