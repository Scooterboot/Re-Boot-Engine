
var rFrame = 0;

image_angle = 0;
var angle = direction+180;
if((direction-45)%90 == 0 && rotFrame > 0)
{
	rFrame = rotFrame;
	angle = direction+225;
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

var xscale = image_xscale,
	yscale = image_yscale;

if(!isSpazer && !isPlasma)
{
	if(isWave && !isIce && !isCharge)
	{
		angle = 0;
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
		angle = -rotation;
	}
    
	if(isCharge)
	{
		for(var i = 0; i < 5; i++)
		{
			var i2 = i+1;
			var scale = lerp(1, 0.25, i2/5),
			alpha = (5 - i2) / 5;
			var xx = oldPosX[i],
			yy = oldPosY[i];
			if(projLength > 0)
			{
				scale = 1;
				xscale = dist;
				if(rFrame != 0)
				{
					dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
					xscale = dist;
					yscale = dist;
				}
			}
			
			draw_sprite_ext(sprite_index,image_index,scr_round(xx),scr_round(yy),xscale*scale,yscale*scale,oldRot[i],c_white,alpha);
		}
	}
}
    
if(projLength > 0)
{
	xscale = dist;
	if(rFrame != 0)
	{
		dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
		xscale = dist;
		yscale = dist;
	}
}

draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),xscale,yscale,angle,c_white,image_alpha);