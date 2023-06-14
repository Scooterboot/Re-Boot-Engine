/// @description 
event_inherited();

mBlocks[0] = noone;
mBlockOffX[0] = 0;
mBlockOffY[0] = 0;

function UpdatePositions()
{
	var player = noone,
		moveX = 0,
		moveY = 0;
	
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		if(instance_exists(mBlocks[i]) && (mBlocks[i].object_index == obj_MovingTile || object_is_ancestor(mBlocks[i].object_index,obj_MovingTile)))
		{
			if (mBlocks[i].CheckPlayer_Top() || mBlocks[i].CheckPlayer_Bottom() ||
				mBlocks[i].CheckPlayer_Left() || mBlocks[i].CheckPlayer_Right())
			{
				player = noone;
				moveX = 0;
				moveY = 0;
				break;
			}
			
			var newBlockPosX = scr_round(x)+scr_round(mBlockOffX[i]),
				newBlockPosY = scr_round(y)+scr_round(mBlockOffY[i]);
			
			var bVelX = newBlockPosX-mBlocks[i].x,
				bVelY = newBlockPosY-mBlocks[i].y;
			
			var getPlayer = noone;
			
			with(mBlocks[i])
			{
				getPlayer = instance_place(newBlockPosX,y,obj_Player);
			}
			if(getPlayer)
			{
				if(bVelX > 0 && !mBlocks[i].CheckPlayer_Right())
				{
					moveX = min(-bVelX, moveX);
				}
				if(bVelX < 0 && !mBlocks[i].CheckPlayer_Left())
				{
					moveX = max(-bVelX, moveX);
				}
				player = getPlayer;
			}
			
			with(mBlocks[i])
			{
				getPlayer = instance_place(x,newBlockPosY,obj_Player);
			}
			if(getPlayer)
			{
				if(bVelY > 0 && !mBlocks[i].CheckPlayer_Bottom())
				{
					moveY = min(-bVelY, moveY);
				}
				if(bVelY < 0 && !mBlocks[i].CheckPlayer_Top())
				{
					moveY = max(-bVelY, moveY);
				}
				player = getPlayer;
			}
		}
	}
	if(instance_exists(player))
	{
		if(moveX != 0 || moveY != 0)
		{
			with(player)
			{
				if(!passthroughMovingSolids)
				{
					Collision_Basic(moveX,moveY,16,16,5,0,5,0);
				}
				xprevious = x;
				yprevious = y;
			}
		}
	}
	
	
	player = noone;
	moveX = 0;
	moveY = 0;
	
	var moveXFlag = false,
		moveYFlag = false;
	
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		if(instance_exists(mBlocks[i]) && (mBlocks[i].object_index == obj_MovingTile || object_is_ancestor(mBlocks[i].object_index,obj_MovingTile)))
		{
			var newBlockPosX = scr_round(x)+scr_round(mBlockOffX[i]),
				newBlockPosY = scr_round(y)+scr_round(mBlockOffY[i]);
			
			var bVelX = newBlockPosX-mBlocks[i].x,
				bVelY = newBlockPosY-mBlocks[i].y;
			
			var getPlayer = noone;
			with(mBlocks[i])
			{
				getPlayer = instance_place(newBlockPosX,newBlockPosY,obj_Player);
			}
			
			var edgeTop = mBlocks[i].CheckPlayer_Top(),
				edgeBottom = mBlocks[i].CheckPlayer_Bottom(),
				edgeLeft = mBlocks[i].CheckPlayer_Left(),
				edgeRight = mBlocks[i].CheckPlayer_Right();
			if(edgeTop)
			{
				getPlayer = edgeTop;
			}
			else if(edgeBottom)
			{
				getPlayer = edgeBottom;
			}
			else if(edgeLeft)
			{
				getPlayer = edgeLeft;
			}
			else if(edgeRight)
			{
				getPlayer = edgeRight;
			}
			
			if(instance_exists(getPlayer))
			{
				player = getPlayer;
				
				var playerEdgeBottom = (player.colEdge == Edge.Bottom),
					playerEdgeTop = (player.colEdge == Edge.Top),
					playerEdgeRight = (player.colEdge == Edge.Right || (player.state == State.Grip && player.dir == 1)),
					playerEdgeLeft = (player.colEdge == Edge.Left || (player.state == State.Grip && player.dir == -1));
				
				moveXFlag = (edgeTop && playerEdgeBottom) ||
							(edgeBottom && playerEdgeTop) ||
							(edgeLeft && (playerEdgeRight || bVelX < 0)) || 
							(edgeRight && (playerEdgeLeft || bVelX > 0));
				
				moveYFlag = (edgeTop && (playerEdgeBottom || bVelY < 0)) || 
							(edgeBottom && (playerEdgeTop || bVelY > 0)) ||
							(edgeLeft && playerEdgeRight) || 
							(edgeRight && playerEdgeLeft);
				
				if(player.spiderBall)
				{
					moveXFlag = true;
					moveYFlag = true;
				}
				with(mBlocks[i])
				{
					if(place_meeting(newBlockPosX,newBlockPosY,player))
					{
						if(!edgeLeft && !edgeRight)
						{
							moveYFlag = true;
						}
						if(!edgeTop && !edgeBottom)
						{
							moveXFlag = true;
						}
					}
				}
				
				if(moveXFlag)
				{
					if(bVelX > 0)
					{
						moveX = max(bVelX, moveX);
					}
					if(bVelX < 0)
					{
						moveX = min(bVelX, moveX);
					}
				}
				if(moveYFlag)
				{
					if(bVelY > 0)
					{
						moveY = max(bVelY, moveY);
					}
					if(bVelY < 0)
					{
						moveY = min(bVelY, moveY);
					}
				}
			}
		}
	}
	
	if(instance_exists(player))
	{
		if(moveX != 0 || moveY != 0)
		{
			var downSlopeX = 5,
				downSlopeY = 5;
			if(moveX != 0)
			{
				downSlopeY = 0;
			}
			if(moveY != 0)
			{
				downSlopeX = 0;
			}
			with(player)
			{
				if(!passthroughMovingSolids)
				{
					if(state == State.Grip && startClimb) //hmmm dont like this
					{
						x += moveX;
						y += moveY;
					}
					else
					{
						Collision_Basic(moveX,moveY,16,16,5,downSlopeX,5,downSlopeY);
					}
				}
			}
		}
	}
	
	for(var i = 0; i < array_length(mBlocks); i++)
	{
		if(instance_exists(mBlocks[i]))
		{
			mBlocks[i].x = scr_round(x)+scr_round(mBlockOffX[i]);
			mBlocks[i].y = scr_round(y)+scr_round(mBlockOffY[i]);
		}
	}
	
	if(instance_exists(player))
	{
		if(moveXFlag)
		{
			moveX -= (player.x-player.xprevious);
		}
		if(moveYFlag)
		{
			moveY -= (player.y-player.yprevious);
		}
		if(moveX != 0 || moveY != 0)
		{
			var downSlopeX = 5,
				downSlopeY = 5;
			if(moveX != 0)
			{
				downSlopeY = 0;
			}
			if(moveY != 0)
			{
				downSlopeX = 0;
			}
			with(player)
			{
				if(!passthroughMovingSolids)
				{
					if(state == State.Grip && startClimb) //todo: rewrite grip climb to be less dumb
					{
						x += moveX;
						y += moveY;
					}
					else
					{
						Collision_Basic(moveX,moveY,16,16,5,downSlopeX,5,downSlopeY);
					}
				}
			}
		}
	}
}