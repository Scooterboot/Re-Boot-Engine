/// @description AI Behavior

if(global.gamePaused)
{
	exit;
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
		var grounded2 = (place_collide(0,ynum) || (bbox_bottom+ynum) >= room_height);
	
		var ynum2 = max(ceil(abs(velX)),8);
		var grounded3 = (place_collide(0,ynum2) || (bbox_bottom+ynum2) >= room_height);
	
		// Slope Speed Adjustment
		if(slopeMovement)
		{
			var yplus3Max = max(ceil(abs(velX)),4),
			sAngle = 90 - 90*sign(velX);
	
			if(abs(velX) >= 1 && grounded)
			{
				var checkValX = min(abs(velX),4)*sign(velX);
				if(place_collide(checkValX,0))
				{
					var yplus3 = 0;
					while(place_collide(checkValX,-yplus3) && yplus3 <= yplus3Max)
					{
						yplus3 = min(yplus3 + 1, yplus3Max+1);
					}
					if(!place_collide(checkValX,-yplus3) && grounded)
					{
						sAngle = point_direction(scr_round(x),scr_round(y), scr_round(x+checkValX),scr_round(y)-yplus3);
					}
				}
			}
			var downHill = false;
	
			cosX = lengthdir_x(abs(velX),sAngle);
			sinX = lengthdir_y(abs(velX),sAngle);
	
			fVelX = cosX;
		}
		else
		{
			fVelX = velX;
		}
	
		collideX = false;
	
		var yplusMax = max(ceil(abs(velX)),3);
	
		// X Collision
		var colR = collision_line(bbox_right+fVelX,bbox_top,bbox_right+fVelX,bbox_bottom,obj_Tile,true,true),
			colL = collision_line(bbox_left+fVelX,bbox_top,bbox_left+fVelX,bbox_bottom,obj_Tile,true,true);
		var xspeed = abs(fVelX);
		if(place_collide(max(abs(fVelX),1)*sign(fVelX),0) && (!place_collide(0,0) || (fVelX > 0 && colR) || (fVelX < 0 && colL)))
		{
			var yplus = 0;
			while(place_collide(fVelX,-yplus) && yplus <= yplusMax && grounded2)
			{
				yplus++;
			}
		
			var xnum = 0;
			while(!place_collide(xnum*sign(fVelX),0) && xnum <= xspeed)
			{
				xnum++;
			}
		
			var walkUpSlope = (!place_collide(xnum*sign(fVelX),-3));
		
			if(place_collide(fVelX,-yplus) || !walkUpSlope || !grounded2 || !slopeMovement)
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
				while(!place_collide(sign(fVelX),0) && xnum2 > 0)
				{
					x += sign(fVelX);
					xnum2--;
				}
			
				velX = 0;
				fVelX = 0;
				collideX = true;
			}
			else
			{
				y -= yplus;
			}
		}
		else if(!place_collide(0,0) && slopeMovement)
		{
			var xnum3 = 0;
			while(place_collide(xnum3*sign(fVelX),1) && xnum3 <= xspeed)
			{
				xnum3++;
			}
		
			var walkDownSlope = (place_collide(xnum3*sign(fVelX),4));
		
			if(walkDownSlope && grounded3 && velY >= 0 && velY <= fGrav)
			{
				var yplus2 = 0;
				while(!place_collide(fVelX,1+yplus2) && yplus2 <= yplusMax)
				{
					yplus2++;
				}
			
				if(!place_collide(fVelX,yplus2))
				{
					if(place_collide(fVelX,yplus2+1) && jump <= 0)
					{
						y += yplus2;
						downHill = true;
					}
				}
			}
		}
	
		x += fVelX;
	
		fVelY = velY;
	
		collideY = false;
	
		// Y Collision
		var colB = collision_line(bbox_left,bbox_bottom+fVelY,bbox_right,bbox_bottom+fVelY,obj_Tile,true,true),
			colT = collision_line(bbox_left,bbox_top+fVelY,bbox_right,bbox_top+fVelY,obj_Tile,true,true);
		if(place_collide(0,max(abs(fVelY),1)*sign(fVelY)) && (!place_collide(0,0) || (fVelY > 0 && colB) || (fVelY < 0 && colT)))
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
			while(!place_collide(0,sign(fVelY)) && yspeed > 0)
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
	
	#region Crawler AI
	if(aiStyle == 0)
	{
		var speedCheck = max(mSpeed,1);
		if(place_collide(speedCheck*dirX,0))
		{
			collideX = true;
		}
		if(place_collide(0,speedCheck*dirY))
		{
			collideY = true;
		}
	
		if(ai[0] == 0)
		{
			dirX = sign(image_xscale);
			dirY = sign(image_xscale);
			rotation = image_angle;
			
			ai[0] = 1;
		}
		var flag = false;
		if(!collideX && !collideY)
		{
			ai[2]++;
			if(ai[2] > 5)
			{
				ai[3] = 2;
			}
		}
		else
		{
			ai[2] = 0;
		}
		if(ai[3] > 0)
		{
			ai[1] = 0;
			ai[0] = 1;
			if(velY > mSpeed)
			{
				//rotation += dirX * radtodeg(0.1);
				if(rotation < 90)
				{
					rotation = min(rotation + radtodeg(0.2),90);
				}
				else
				{
					rotation = max(rotation - radtodeg(0.2),90);
				}
			}
			else
			{
				rotation = 0;
			}
			velX = 0;//mSpeed * dirX;
			dirY = 1;
			velY += min(fGrav,max(fallSpeedMax-velY,0));
		
			if(collideX || collideY)
			{
				ai[3]--;
			}
		}
		if(ai[3] == 0)
		{
			var flag2 = false;
			if(place_collide(0,0))
			{
				flag2 = true;
			
				var flag3 = false;
				if(!collision_line(bbox_right+1,bbox_top,bbox_right+1,bbox_bottom,obj_Tile,true,true))
				{
					dirX = 1;
				}
				else if(!collision_line(bbox_left-1,bbox_top,bbox_left-1,bbox_bottom,obj_Tile,true,true))
				{
					dirX = -1;
				}
				else
				{
					dirX *= -1;
					flag3 = true;
				}
			
				if(!collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Tile,true,true))
				{
					dirY = 1;
				}
				else if(!collision_line(bbox_left,bbox_top-1,bbox_right,bbox_top-1,obj_Tile,true,true) || flag3)
				{
					dirY = -1;
				}
				else
				{
					dirY *= -1;
				}
			}
			else
			{
				if(ai[1] == 0)
				{
					if(collideY)
					{
						if(ai[0] < 2)
						{
							ai[0] = 2;
						}
					}
					if(!collideY && ai[0] >= 2)
					{
						ai[0]++;
						if(ai[0] > 3)
						{
							dirX = -dirX;
							ai[1] = 1;
							ai[0] = 1;
						}
					}
					if(collideX)
					{
						dirY = -dirY;
						ai[1] = 1;
					}
				}
				else
				{
					if(collideX)
					{
						if(ai[0] < 2)
						{
							ai[0] = 2;
						}
					}
					if(!collideX && ai[0] >= 2)
					{
						ai[0]++;
						if(ai[0] > 3)
						{
							dirY = -dirY;
							ai[1] = 0;
							ai[0] = 1;
						}
					}
					if(collideY)
					{
						dirX = -dirX;
						ai[1] = 0;
					}
				}
			}
			
			if(!flag)
			{
				var b_rot = 0,
					r_rot = 90,
					t_rot = 180,
					l_rot = 270;
		
				var rot = rotation;
				if(dirY < 0)
				{
					if(dirX < 0)
					{
						if(collideX)
						{
							rotation = l_rot;
							image_xscale = -1 * abs(image_xscale);
						}
						else if(collideY)
						{
							rotation = t_rot;
							image_xscale = 1 * abs(image_xscale);
						}
					}
					else if(collideY)
					{
						rotation = t_rot;
						image_xscale = -1 * abs(image_xscale);
					}
					else if(collideX)
					{
						rotation = r_rot;
						image_xscale = 1 * abs(image_xscale);
					}
				}
				else if(dirX < 0)
				{
					if(collideY)
					{
						rotation = b_rot;
						image_xscale = -1 * abs(image_xscale);
					}
					else if(collideX)
					{
						rotation = l_rot;
						image_xscale = 1 * abs(image_xscale);
					}
				}
				else if(collideX)
				{
					rotation = r_rot;
					image_xscale = -1 * abs(image_xscale);
				}
				else if(collideY)
				{
					rotation = b_rot;
					image_xscale = 1 * abs(image_xscale);
				}
		
				var br_slope_rot = 45,
					tr_slope_rot = 135,
					tl_slope_rot = 225,
					bl_slope_rot = 315;
				var offY = 0;
				var bottom = place_collide(0,2),
					left = place_collide(-2,0),
					top = place_collide(0,-2),
					right = place_collide(2,0);
				if(left)
				{
					if(bottom)
					{
						rotation = bl_slope_rot;
						offY = 3;
					}
					if(top)
					{
						rotation = tl_slope_rot;
						offY = 3;
					}
				}
				if(right)
				{
					if(bottom)
					{
						rotation = br_slope_rot;
						offY = 3;
					}
					if(top)
					{
						rotation = tr_slope_rot;
						offY = 3;
					}
				}
				if(offsetY < offY)
				{
					offsetY = min(offsetY+1,offY);
				}
				else
				{
					offsetY = max(offsetY-1,offY);
				}
		
				var rot2 = rotation;
				rotation = rot;
				if(rotation > 360)
				{
					rotation -= 360;
				}
				if(rotation < 0)
				{
					rotation += 360;
				}
				var rot3 = abs(rotation - rot2),
					rotRate = radtodeg(0.1);
				if(rotation > rot2)
				{
					if(rot3 > 180)
					{
						rotation += rotRate;
					}
					else
					{
						rotation -= rotRate;
						if(rotation < rot2)
						{
							rotation = rot2;
						}
					}
				}
				if(rotation < rot2)
				{
					if(rot3 > 180)
					{
						rotation -= rotRate;
					}
					else
					{
						rotation += rotRate;
						if(rotation > rot2)
						{
							rotation = rot2;
						}
					}
				}
			}
			var speed2 = mSpeed;
			if(!place_collide(speedCheck*dirX,speedCheck*dirY) && !fullSpeedOnSlopes)
			{
				speed2 = lengthdir_x(mSpeed,45);
			}
			velX = speed2 * dirX;
			velY = speed2 * dirY;
			if(flag2)
			{
				x += velX;
				y += velY;
			}
		}
	}
	#endregion
}
#region General Behavior
if(justHit)
{
	//insert stuff here...?
	justHit = false;
}

if(frozen > 0 && !dead)
{
	if(!instance_exists(freezePlatform))
	{
	    freezePlatform = instance_create_layer(bbox_left,bbox_top,layer_get_id("Collision"),obj_Platform);
	    freezePlatform.image_xscale = (bbox_right-bbox_left)/16;
	    freezePlatform.image_yscale = (bbox_bottom-bbox_top)/16;
	}
}
else if(instance_exists(freezePlatform))
{
	instance_destroy(freezePlatform);
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);
#endregion
#region Damage to Player
if(!friendly && damage > 0 && !frozen && !dead)
{
    var player = instance_place(x,y,obj_Player);
    if(instance_exists(player))
    {
        if (player.immuneTime <= 0 && !player.isScrewAttacking && !player.isSpeedBoosting)
        {
            //var ang = point_direction(x,y,obj_Samus.x,obj_Samus.y);
            var ang = 45;
            if(player.bbox_bottom > bbox_bottom)
            {
                ang = 315;
            }
            if(player.x < x)
            {
                ang = 135;
                if(player.bbox_bottom > bbox_bottom)
                {
                    ang = 225;
                }
            }
            var knockX = lengthdir_x(knockBackSpeed,ang),
                knockY = lengthdir_y(knockBackSpeed,ang);
            scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
        }
    }
}
#endregion