
//if(!isSpazer || isPlasma)
if(!isSpazer && !isPlasma)
{
	/*if(isPlasma)
	{
		if(impact <= 0 && !global.gamePaused)
		{
			var velAngX = x-(oldPosX[0]+speed_x),
			velAngY = y-(oldPosY[0]+speed_y),
			nVelX = lengthdir_x(velocity,direction),
			nVelY = lengthdir_y(velocity,direction);
			if(point_distance(x,y,x+velAngX,y+velAngY) < point_distance(x,y,x+nVelX,y+nVelY))
			{
				image_angle = direction;
			}
			else
			{
				image_angle = point_direction(0,0,velAngX,velAngY);
			}
		}
		image_angle = direction;
	}
	else*/ if(isWave && !isIce && !isCharge)
	{
		image_angle = 0;
	}
	else if((isIce || isCharge))
	{
		var rotspeed = 30;
		i = 1;
		if(waveStyle == 1)
		{
			i = -1;
		}
		rot += rotspeed*dir*i*(!global.gamePaused);
		image_angle = -rot;
	}
        
	if(!global.gamePaused)
	{
		if(!oldPositionsSet)
		{
			for(var i = 0; i < 11; i++)
			{
				oldPosX[i] = x;
				oldPosY[i] = y;
			}
			for(var i = 0; i < 11; i++)
			{
				oldRot[i] = image_angle;
			}
			oldPositionsSet = true;
		}
    
		for(var i = 10; i > 0; i--)
		{
			oldPosX[i] = oldPosX[i - 1];
			oldPosY[i] = oldPosY[i - 1];
		}
		oldPosX[0] = x;
		oldPosY[0] = y;
            
		for(var i = 10; i > 0; i--)
		{
			oldRot[i] = oldRot[i - 1];
		}
		oldRot[0] = image_angle;
	}
    
	if(isCharge)// || isPlasma)
	{
		for(var i = 1; i < 5; i++)
		{
			scale = lerp(1, 0.25, i/5);
			alpha = (5 - i) / 5;
			var xx = oldPosX[i],
			yy = oldPosY[i];
			if(sprite_xoffset > 15)
			{
				scale = 1;
				scr_PlasmaDraw(xx,yy,scale,scale,oldRot[i],alpha);
			}
			else
			{
				draw_sprite_ext(sprite_index,image_index,scr_round(xx),scr_round(yy),scale,scale,oldRot[i],c_white,alpha);
			}
		}
	}
}
    
if(sprite_xoffset >= 15)
{
	scr_PlasmaDraw(x,y,1,1,image_angle,image_alpha,true);
}
else
{
	draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),1,1,image_angle,c_white,image_alpha);
}