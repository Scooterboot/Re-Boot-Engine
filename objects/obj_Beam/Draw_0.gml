
var rFrame = 0;

image_angle = direction+180;
if((direction-45)%90 == 0 && rotFrame > 0)
{
	rFrame = rotFrame;
	image_angle = direction+225;
}
if((image_number-rotFrame) > 1)
{
	frame = scr_wrap(frame+1,0,image_number-rotFrame);
}
image_index = rFrame+frame;

var dist = 0;
if(projLength > 0)
{
	if(!global.gamePaused)
	{
	    xstart += speed_x;
	    ystart += speed_y;
	}
	dist = clamp((point_distance(x,y,xstart,ystart) + 4 + sprite_xoffset)/projLength,0,1);
}

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
		rotation += rotspeed*dir*i*(!global.gamePaused);
		image_angle = -rotation;
	}
    
	if(isCharge)// || isPlasma)
	{
		for(var i = 0; i < 5; i++)
		{
			var i2 = i+1;
			var scale = lerp(1, 0.25, i2/5),
			alpha = (5 - i2) / 5;
			var xx = oldPosX[i],
			yy = oldPosY[i];
			//if(sprite_xoffset > 15)
			if(projLength > 0)
			{
				//scale = 1;
				//scr_PlasmaDraw(xx,yy,scale,scale,oldRot[i],alpha);
				scale = 1;
				image_xscale = dist;
				if(rFrame != 0)
				{
					dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
					image_xscale = dist;
					image_yscale = dist;
				}
			}
			//else
			//{
				draw_sprite_ext(sprite_index,image_index,scr_round(xx),scr_round(yy),image_xscale*scale,image_yscale*scale,oldRot[i],c_white,alpha);
			//}
		}
	}
}
    
//if(sprite_xoffset >= 15)
if(projLength > 0)
{
	//scr_PlasmaDraw(x,y,1,1,image_angle,image_alpha,true);
	image_xscale = dist;
	if(rFrame != 0)
	{
		dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
		image_xscale = dist;
		image_yscale = dist;
	}
}
//else
//{
	draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),image_xscale,image_yscale,image_angle,c_white,image_alpha);
//}