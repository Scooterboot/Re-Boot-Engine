/// @description 

if(impacted <= 0)
{
	image_angle = direction+180;
	if((direction-45)%90 == 0 && rotFrame > 0)
	{
		rFrame = rotFrame;
		image_angle = direction+225;
	}
	var velAngX = x-(oldPosX[0]+speed_x),
		velAngY = y-(oldPosY[0]+speed_y),
		nVelX = velX,//lengthdir_x(velocity,direction),
		nVelY = velY,//lengthdir_y(velocity,direction);
	if(point_distance(x,y,x+velAngX,y+velAngY) >= point_distance(x,y,x+nVelX,y+nVelY))
	{
		image_angle = point_direction(0,0,velAngX,velAngY)+180;
		if(rFrame != 0)
		{
			image_angle = point_direction(0,0,velAngX,velAngY)+225;
		}
	}
}
if((image_number-rotFrame) > 1)
{
	frame = scr_wrap(frame+1,0,image_number-rotFrame);
}
image_index = rFrame+frame;

if(!global.gamePaused)
{
	xstart += speed_x;
	ystart += speed_y;
	
	for(var i = 0; i < 11; i++)
	{
		oldPosX[i] += speed_x;
		oldPosY[i] += speed_y;
	}
}

for(var i = 0; i < 5; i++)
{
	var i2 = i+1;
	var alpha = (5 - i2) / 5;
	var xx = oldPosX[i],
	yy = oldPosY[i];
	
	var dist2 = clamp((point_distance(xx,yy,xstart,ystart) + 4 + sprite_xoffset)/projLength,0,1);
	var xscale = dist2,
		yscale = 1;
	if(rFrame != 0)
	{
		dist2 = clamp((lengthdir_x(point_distance(xx,yy,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
		xscale = dist2;
		yscale = dist2;
	}
	
	pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
	draw_sprite_ext(sprite_index,image_index,scr_round(xx),scr_round(yy),xscale,yscale,oldRot[i],c_white,alpha);
	shader_reset();
}

var dist = clamp((point_distance(x,y,xstart,ystart) + 4 + sprite_xoffset)/projLength,0,1);
image_xscale = dist;
if(rFrame != 0)
{
	dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 4,45) + sprite_xoffset)/projLength,0,1);
	image_xscale = dist;
	image_yscale = dist;
}

pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),image_xscale,image_yscale,image_angle,c_white,image_alpha);
shader_reset();

//if(firedFrame <= 5)
if(fired < 4)
{
	var sSprt = sprt_HyperBeamStartParticle;
	//firedFrameCounter++;
	//if(firedFrameCounter > 2)
	//{
		firedFrame = scr_wrap(firedFrame+1,0,sprite_get_number(sSprt));
		firedFrameCounter = 0;
		
		if(firedFrame == sprite_get_number(sSprt)-1)
		{
			fired++;
		}
	//}
	
	var hObj = id;//self;
	
	with(obj_Player)
	{
		pal_swap_set(sprt_HyperBeamPalette,1+obj_Main.hyperRainbowCycle,0,0,false);
		draw_sprite_ext(sSprt,hObj.firedFrame,scr_round(shootPosX),scr_round(shootPosY),1,1,0,c_white,1);
		shader_reset();
		
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_HyperBeamStartParticle_Glow,hObj.firedFrame,scr_round(shootPosX),scr_round(shootPosY),1,1,0,c_white,0.75);
		gpu_set_blendmode(bm_normal);
	}
}
