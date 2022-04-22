/// @description AI Behavior
event_inherited();
if(global.gamePaused || !scr_WithinCamRange())
{
	exit;
}

if(frozen <= 0)
{
	if(ai[0] == 0)
	{
		dirX = sign(image_xscale);
		dirY = sign(image_xscale);
		rotation = image_angle;
		rotation2 = rotation;
			
		ai[0] = 1;
	}
	
	var rot = rotation2;
	
	//var collideAny = (lhc_place_collide(1,0) || lhc_place_collide(-1,0) || lhc_place_collide(0,1) || lhc_place_collide(0,-1)
	//				|| lhc_place_collide(1,1) || lhc_place_collide(-1,1) || lhc_place_collide(1,-1) || lhc_place_collide(-1,-1));
	var xcheck = max(abs(velX),1),
		ycheck = max(abs(velY),1);
	var collideAny = (lhc_place_collide(xcheck,0) || lhc_place_collide(-xcheck,0) || lhc_place_collide(0,ycheck) || lhc_place_collide(0,-ycheck)
					|| lhc_place_collide(xcheck,ycheck) || lhc_place_collide(-xcheck,ycheck) || lhc_place_collide(xcheck,-ycheck) || lhc_place_collide(-xcheck,-ycheck));
	
	if(!collideAny)
	{
		ai[1]++;
		if(ai[1] > 2)
		{
			ai[2] = 2;
			edge = Edge.None;
		}
	}
	else
	{
		ai[1] = 0;
	}
	if(ai[2] > 0)
	{
		tileCollide = true;
		
		if(velY > fGrav)
		{
			if(dirX > 0)
			{
				rotation2 = 90;
			}
			else
			{
				rotation2 = 270;
			}
		}
		else
		{
			rotation2 = 0;
		}
		velX = 0;//mSpeed * dirX;
		dirY = 1;
		velY += min(fGrav,max(fallSpeedMax-velY,0));
		
		if(collideAny)
		{
			ai[2]--;
			if(ai[2] <= 0)
			{
				if(lhc_place_collide(0,ycheck))
				{
					edge = Edge.Bottom;
					dirY = 1;
				}
				else if(lhc_place_collide(0,-ycheck))
				{
					edge = Edge.Top;
					dirY = -1;
				}
				else if(lhc_place_collide(xcheck,0))
				{
					edge = Edge.Right;
					dirX = 1;
				}
				else if(lhc_place_collide(-xcheck,0))
				{
					edge = Edge.Left;
					dirX = -1;
				}
			}
		}
	}
	if(ai[2] == 0)
	{
		tileCollide = false;
		
		if(lhc_place_collide(0,0))
		{
			var flag3 = false;
			if(!lhc_collision_line(bbox_right+1,bbox_top,bbox_right+1,bbox_bottom,"ISolid",true,true))
			{
				dirX = 1;
			}
			else if(!lhc_collision_line(bbox_left-1,bbox_top,bbox_left-1,bbox_bottom,"ISolid",true,true))
			{
				dirX = -1;
			}
			else
			{
				dirX *= -1;
				flag3 = true;
			}
			
			if(!lhc_collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,"ISolid",true,true))
			{
				dirY = 1;
			}
			else if(!lhc_collision_line(bbox_left,bbox_top-1,bbox_right,bbox_top-1,"ISolid",true,true) || flag3)
			{
				dirY = -1;
			}
			else
			{
				dirY *= -1;
			}
			
			velX = mSpeed*dirX;
			velY = mSpeed*dirY;
			x += velX;
			y += velY;
		}
		else
		{
			switch(edge)
			{
				case Edge.Bottom:
				{
					dirY = 1;
					break;
				}
				case Edge.Left:
				{
					dirX = -1;
					break;
				}
				case Edge.Top:
				{
					dirY = -1;
					break;
				}
				case Edge.Right:
				{
					dirX = 1;
					break;
				}
			}
			
			velX = mSpeed*dirX;
			
			fVelX = velX;
	
			var yplusMax = max(ceil(abs(velX)),1);
	
			// X Collision
			var colR = lhc_collision_line(bbox_right+fVelX,bbox_top,bbox_right+fVelX,bbox_bottom,"ISolid",true,true),
				colL = lhc_collision_line(bbox_left+fVelX,bbox_top,bbox_left+fVelX,bbox_bottom,"ISolid",true,true);
			var xspeed = abs(fVelX);
			if(lhc_place_collide(max(abs(fVelX),1)*sign(fVelX),0) && (!lhc_place_collide(0,0) || (fVelX > 0 && colR) || (fVelX < 0 && colL)))
			{
				var yplus = 0;
				if(dirY == 1 && edge == Edge.Bottom)
				{
					while(lhc_place_collide(fVelX,yplus) && yplus >= -yplusMax)
					{
						yplus--;
					}
				}
				else if(dirY == -1 && edge == Edge.Top)
				{
					while(lhc_place_collide(fVelX,yplus) && yplus <= yplusMax)
					{
						yplus++;
					}
				}
		
				var xnum = 0;
				while(!lhc_place_collide(xnum*sign(fVelX),0) && xnum <= xspeed)
				{
					xnum++;
				}
		
				var walkUpSlope = (!lhc_place_collide(xnum*sign(fVelX),-dirY));
				var horizontalEdge = ((dirY == 1 && edge == Edge.Bottom) || (dirY == -1 && edge == Edge.Top));
		
				if(lhc_place_collide(fVelX,yplus) || !walkUpSlope || !horizontalEdge || edge == Edge.None)
				{
					if(fVelX > 0)
					{
						x = scr_floor(x);
						if(horizontalEdge || edge == Edge.None)
						{
							if(horizontalEdge)
							{
								dirY *= -1;
							}
							edge = Edge.Right;
						}
					}
					if(fVelX < 0)
					{
						x = scr_ceil(x);
						if(horizontalEdge || edge == Edge.None)
						{
							if(horizontalEdge)
							{
								dirY *= -1;
							}
							edge = Edge.Left;
						}
					}
					
					var xnum2 = xspeed+2;
					while(!lhc_place_collide(sign(fVelX),0) && xnum2 > 0)
					{
						x += sign(fVelX);
						xnum2--;
					}
			
					velX = 0;
					fVelX = 0;
				}
				else
				{
					y = scr_round(y + yplus);
				}
			}
			else if(!lhc_place_collide(0,0) && (edge == Edge.Bottom || edge == Edge.Top))
			{
				var xnum3 = 0;
				while(lhc_place_collide(xnum3*sign(fVelX),dirY) && xnum3 <= xspeed)
				{
					xnum3++;
				}
		
				var walkDownSlope = (lhc_place_collide(xnum3*sign(fVelX),2*dirY));
		
				if(walkDownSlope)
				{
					var yplus2 = 0;
					if(dirY == 1 && edge == Edge.Bottom)
					{
						while(!lhc_place_collide(fVelX,dirY+yplus2) && yplus2 <= yplusMax)
						{
							yplus2++;
						}
					}
					else if(dirY == -1 && edge == Edge.Top)
					{
						while(!lhc_place_collide(fVelX,dirY+yplus2) && yplus2 >= -yplusMax)
						{
							yplus2--;
						}
					}
			
					if(!lhc_place_collide(fVelX,yplus2))
					{
						if(lhc_place_collide(fVelX,yplus2+dirY))// && jump <= 0)
						{
							y += yplus2;
						}
					}
				}
				else if(lhc_place_collide(0,dirY))
				{
					if(fVelX > 0)
					{
						x = scr_floor(x);
						edge = Edge.Left;
						dirX = -1;
					}
					if(fVelX < 0)
					{
						x = scr_ceil(x);
						edge = Edge.Right;
						dirX = 1;
					}
					var xnum2 = xspeed+2;
					while(lhc_place_collide(0,dirY) && xnum2 > 0)
					{
						x += sign(fVelX);
						xnum2--;
					}
					
					velX = 0;
					fVelX = 0;
					if(!lhc_place_collide(0,dirY))
					{
						y += dirY;
					}
				}
				else
				{
					velX = 0;
					fVelX = 0;
				}
			}
	
			x += fVelX;
			
			
			velY = mSpeed*dirY;
			
			fVelY = velY;
			
			var xplusMax = max(ceil(abs(velY)),1);
	
			// Y Collision
			var colB = lhc_collision_line(bbox_left,bbox_bottom+fVelY,bbox_right,bbox_bottom+fVelY,"ISolid",true,true),
				colT = lhc_collision_line(bbox_left,bbox_top+fVelY,bbox_right,bbox_top+fVelY,"ISolid",true,true);
			var yspeed = abs(fVelY);
			if(lhc_place_collide(0,max(abs(fVelY),1)*sign(fVelY)) && (!lhc_place_collide(0,0) || (fVelY > 0 && colB) || (fVelY < 0 && colT)))
			{
				var xplus = 0;
				if(dirX == 1 && edge == Edge.Right)
				{
					while(lhc_place_collide(xplus,fVelY) && xplus >= -xplusMax)
					{
						xplus--;
					}
				}
				else if(dirX == -1 && edge == Edge.Left)
				{
					while(lhc_place_collide(xplus,fVelY) && xplus <= xplusMax)
					{
						xplus++;
					}
				}
		
				var ynum = 0;
				while(!lhc_place_collide(0,ynum*sign(fVelY)) && ynum <= yspeed)
				{
					ynum++;
				}
		
				var walkUpSlope = (!lhc_place_collide(-dirX,ynum*sign(fVelY)));
				var verticalEdge = ((edge == Edge.Left && dirX == -1) || (edge == Edge.Right && dirX == 1));
		
				if(lhc_place_collide(xplus,fVelY) || !walkUpSlope || !verticalEdge || edge == Edge.None)
				{
					if(fVelY > 0)
					{
						y = scr_floor(y);
						if(verticalEdge || edge == Edge.None)
						{
							if(verticalEdge)
							{
								dirX *= -1;
							}
							edge = Edge.Bottom;
						}
					}
					if(fVelY < 0)
					{
						y = scr_ceil(y);
						if(verticalEdge || edge == Edge.None)
						{
							if(verticalEdge)
							{
								dirX *= -1;
							}
							edge = Edge.Top;
						}
					}
					
					var ynum2 = yspeed+2;
					while(!lhc_place_collide(0,sign(fVelY)) && ynum2 > 0)
					{
						y += sign(fVelY);
						ynum2--;
					}
		
					fVelY = 0;
					velY = 0;
				}
				else
				{
					x = scr_round(x + xplus);
				}
			}
			else if(!lhc_place_collide(0,0) && (edge == Edge.Left || edge == Edge.Right))
			{
				var ynum3 = 0;
				while(lhc_place_collide(dirX,ynum3*sign(fVelY)) && ynum3 <= yspeed)
				{
					ynum3++;
				}
		
				var walkDownSlope = (lhc_place_collide(2*dirX,ynum3*sign(fVelY)));
		
				if(walkDownSlope)
				{
					var xplus2 = 0;
					if(dirX == 1 && edge == Edge.Right)
					{
						while(!lhc_place_collide(dirX+xplus2,fVelY) && xplus2 <= xplusMax)
						{
							xplus2++;
						}
					}
					else if(dirX == -1 && edge == Edge.Left)
					{
						while(!lhc_place_collide(dirX+xplus2,fVelY) && xplus2 >= -xplusMax)
						{
							xplus2--;
						}
					}
			
					if(!lhc_place_collide(xplus2,fVelY))
					{
						if(lhc_place_collide(xplus2+dirX,fVelY))// && jump <= 0)
						{
							x += xplus2;
						}
					}
				}
				else if(lhc_place_collide(dirX,0))
				{
					if(fVelY > 0)
					{
						y = scr_floor(y);
						edge = Edge.Top;
						dirY = -1;
					}
					if(fVelY < 0)
					{
						y = scr_ceil(y);
						edge = Edge.Bottom;
						dirY = 1;
					}
					var ynum2 = yspeed+2;
					while(lhc_place_collide(dirX,0) && ynum2 > 0)
					{
						y += sign(fVelY);
						ynum2--;
					}
					
					fVelY = 0;
					velY = 0;
					if(!lhc_place_collide(dirX,0))
					{
						x += dirX;
					}
				}
				else
				{
					fVelY = 0;
					velY = 0;
				}
			}
	
			y += fVelY;
	
			x = clamp(x,x-bbox_left,room_width-(bbox_right-x));
			y = clamp(y,y-bbox_top,room_height-(bbox_bottom-y));
			
			var bottom_rot = 0,
			left_rot = 270,
			top_rot = 180,
			right_rot = 90;
			
			switch(edge)
			{
				case Edge.Bottom:
				{
					rotation2 = bottom_rot;
					break;
				}
				case Edge.Left:
				{
					rotation2 = left_rot;
					break;
				}
				case Edge.Top:
				{
					rotation2 = top_rot;
					break;
				}
				case Edge.Right:
				{
					rotation2 = right_rot;
					break;
				}
			}
			
			var slopeFlag = false;
			for(var k = 0; k < 4; k++)
			{
				var x1 = bbox_left-1,
					x2 = x,
					y1 = bbox_top-1,
					y2 = y;
				switch (k)
				{
					case 1:
					{
						x1 = x;
						x2 = bbox_right+1;
						y1 = bbox_top-1;
						y2 = y;
						break;
					}
					case 2:
					{
						x1 = bbox_left-1;
						x2 = x;
						y1 = y;
						y2 = bbox_bottom+1;
						break;
					}
					case 3:
					{
						x1 = x;
						x2 = bbox_right+1;
						y1 = y;
						y2 = bbox_bottom+1;
						break;
					}
					default:
					{
						break;
					}
				}
				
				var dlist = ds_list_create();
				var col = collision_rectangle_list(x1,y1,x2,y2,obj_Slope,true,true,dlist,true);
				for(var i = 0; i < col; i++)
				{
					var slope = dlist[| i];
					if(instance_exists(slope) && (
					(k == 0 && slope.image_xscale > 0 && slope.image_yscale < 0) ||
					(k == 1 && slope.image_xscale < 0 && slope.image_yscale < 0) ||
					(k == 2 && slope.image_xscale > 0 && slope.image_yscale > 0) ||
					(k == 3 && slope.image_xscale < 0 && slope.image_yscale > 0)))
					{
						rotation2 = scr_GetSlopeAngle(slope);
						slopeFlag = true;
					}
				}
				ds_list_destroy(dlist);
			}
			
			if(slopeFlag)
			{
				offsetY2 = min(offsetY2+0.1,2.9);
			}
			else
			{
				offsetY2 = max(offsetY2-0.25,0);
			}
			
			//var rot4 = scr_wrap(rotation2*2,0,360);
			//offsetY = abs(offsetY2*dsin(rot4));
		}
	}
	else
	{
		offsetY2 = 0;
		offsetY = max(offsetY-0.5,0);
	}
	
	var rot2 = scr_round(rotation2);
	rotation2 = rot;
	if(rotation2 > 360)
	{
		rotation2 -= 360;
	}
	if(rotation2 < 0)
	{
		rotation2 += 360;
	}
	var rot3 = abs(rotation2 - rot2),
		rotRate = radtodeg(0.2) * mSpeed;
	if(rotation2 > rot2)
	{
		if(rot3 > 180)
		{
			rotation2 += rotRate;
		}
		else
		{
			rotation2 = max(rotation2-rotRate,rot2);
		}
	}
	if(rotation2 < rot2)
	{
		if(rot3 > 180)
		{
			rotation2 -= rotRate;
		}
		else
		{
			rotation2 = min(rotation2+rotRate,rot2);
		}
	}
	rotation = scr_round(rotation2/5.625)*5.625;
}
