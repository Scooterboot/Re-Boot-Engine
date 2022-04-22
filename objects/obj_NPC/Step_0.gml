/// @description AI Behavior

if(global.gamePaused)
{
	exit;
}

if(setOldPoses == 0)
{
	for(var i = 0; i < 10; i++)
	{
		oldPosX[i] = x;
		oldPosY[i] = y;
	}
	setOldPoses = 1;
}

if(frozen <= 0)
{
	grounded = ((collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Tile,true,true) || 
	(collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Platform,true,true) && !place_meeting(x,y,obj_Platform)) || 
	(bbox_bottom+1) >= room_height) && velY >= 0 && velY <= fGrav);

	if(tileCollide)
	{
		#region Collision
	
		var ynum = max(ceil(abs(velX)),1);
		var grounded2 = (lhc_place_collide(0,ynum) || (bbox_bottom+ynum) >= room_height);
	
		var ynum2 = max(ceil(abs(velX)),8);
		var grounded3 = (lhc_place_collide(0,ynum2) || (bbox_bottom+ynum2) >= room_height);
	
		// Slope Speed Adjustment
		if(slopeMovement)
		{
			var sAngle = 90 - 90*sign(velX);
			if(abs(velX) >= 1 && grounded)
			{
				var slope = instance_place(x+velX,y,obj_Slope);
				if(instance_exists(slope) && slope.image_yscale > 0 && (slope.image_yscale <= 1 || abs(velX) < 1.5) && sign(slope.image_xscale) == -sign(velX))
				{
					sAngle += scr_GetSlopeAngle(slope);
				}
				else
				{
					slope = instance_place(x,y+abs(velX),obj_Slope);
					if(instance_exists(slope) && slope.image_yscale > 0 && (slope.image_yscale <= 1 || abs(velX) < 1.5) && sign(slope.image_xscale) == sign(velX) &&
					((slope.image_xscale > 0 && bbox_left >= slope.bbox_left-2) || (slope.image_xscale < 0 && bbox_right <= slope.bbox_right+2)))
					{
						sAngle += scr_GetSlopeAngle(slope);
					}
				}
			}
	
			cosX = lengthdir_x(abs(velX),sAngle);
			sinX = lengthdir_y(abs(velX),sAngle);
	
			fVelX = cosX;
		}
		else
		{
			fVelX = velX;
		}
	
		collideX = false;
	
		var yplusMax = max(ceil(abs(velX)),4);
	
		// X Collision
		var colR = lhc_collision_line(bbox_right+fVelX,bbox_top,bbox_right+fVelX,bbox_bottom,"ISolid",true,true),
			colL = lhc_collision_line(bbox_left+fVelX,bbox_top,bbox_left+fVelX,bbox_bottom,"ISolid",true,true);
		var xspeed = abs(fVelX);
		if(lhc_place_collide(max(abs(fVelX),1)*sign(fVelX),0) && (!lhc_place_collide(0,0) || (fVelX > 0 && colR) || (fVelX < 0 && colL)))
		{
			var yplus = 0;
			while(lhc_place_collide(fVelX,-yplus) && yplus <= yplusMax && grounded2)
			{
				yplus++;
			}
		
			var xnum = 0;
			while(!lhc_place_collide(xnum*sign(fVelX),0) && xnum <= xspeed)
			{
				xnum++;
			}
		
			var walkUpSlope = (!lhc_place_collide(xnum*sign(fVelX),-3));
		
			if(lhc_place_collide(fVelX,-yplus) || !walkUpSlope || !grounded2 || !slopeMovement)
			{
				if(fVelX > 0)
				{
					x = scr_floor(x);
				}
				if(fVelX < 0)
				{
					x = scr_ceil(x);
				}
				var xnum2 = xspeed+2;
				while(!lhc_place_collide(sign(fVelX),0) && xnum2 > 0)
				{
					x += sign(fVelX);
					xnum2--;
				}
			
				velX = 0;
				fVelX = 0;
				collideX = true;
			}
			else if(grounded2)
			{
				y = scr_round(y - yplus);
			}
		}
		else if(!lhc_place_collide(0,0) && slopeMovement)
		{
			var xnum3 = 0;
			while(lhc_place_collide(xnum3*sign(fVelX),1) && xnum3 <= xspeed)
			{
				xnum3++;
			}
		
			var walkDownSlope = (lhc_place_collide(xnum3*sign(fVelX),3));
		
			if(walkDownSlope && grounded3 && velY >= 0 && velY <= fGrav)
			{
				var yplus2 = 0;
				while(!lhc_place_collide(fVelX,1+yplus2) && yplus2 <= yplusMax)
				{
					yplus2++;
				}
			
				if(!lhc_place_collide(fVelX,yplus2))
				{
					if(lhc_place_collide(fVelX,yplus2+1))// && jump <= 0)
					{
						y += yplus2;
					}
				}
			}
		}
	
		x += fVelX;
	
		fVelY = velY;
	
		collideY = false;
	
		// Y Collision
		var colB = lhc_collision_line(bbox_left,bbox_bottom+fVelY,bbox_right,bbox_bottom+fVelY,"ISolid",true,true),
			colT = lhc_collision_line(bbox_left,bbox_top+fVelY,bbox_right,bbox_top+fVelY,"ISolid",true,true);
		if(lhc_place_collide(0,max(abs(fVelY),1)*sign(fVelY)) && (!lhc_place_collide(0,0) || (fVelY > 0 && colB) || (fVelY < 0 && colT)))
		{
			if(fVelY > 0)
			{
				y = scr_floor(y);
			}
			if(fVelY < 0)
			{
				y = scr_ceil(y);
			}
			var yspeed = abs(fVelY)+2;
			while(!lhc_place_collide(0,sign(fVelY)) && yspeed > 0)
			{
				y += sign(fVelY);
				yspeed--;
			}
		
			fVelY = 0;
			velY = 0;
			collideY = true;
		}
	
		y += fVelY;
	
		x = clamp(x,x-bbox_left,room_width-(bbox_right-x));
		y = clamp(y,y-bbox_top,room_height-(bbox_bottom-y));
	
		#endregion
	}
}
