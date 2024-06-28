/// @description 

image_angle = 0;
var angle = direction+180;
if((direction-45)%90 == 0 && rotFrame > 0)
{
	rFrame = rotFrame;
	angle = direction+225;
}
var velAngX = x-(oldPosX[0]),//+speed_x),
	velAngY = y-(oldPosY[0]),//+speed_y),
	nVelX = velX,//lengthdir_x(velocity,direction),
	nVelY = velY;//lengthdir_y(velocity,direction);
if(point_distance(x,y,x+velAngX,y+velAngY) >= point_distance(x,y,x+nVelX,y+nVelY))
{
	angle = point_direction(0,0,velAngX,velAngY)+180;
	if(rFrame != 0)
	{
		angle = point_direction(0,0,velAngX,velAngY)+225;
	}
}
if((image_number-rotFrame) > 1)
{
	frame = scr_wrap(frame+1,0,image_number-rotFrame);
}
image_index = rFrame+frame;

/*if(!global.gamePaused)
{
	xstart += speed_x;
	ystart += speed_y;
	
	for(var i = 0; i < 11; i++)
	{
		oldPosX[i] += speed_x;
		oldPosY[i] += speed_y;
	}
}*/

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
	
	chameleon_set(sprt_HyperBeamPalette,obj_Display.hyperRainbowCycle,0,0,11);
	draw_sprite_ext(sprite_index,image_index,scr_round(xx),scr_round(yy),xscale,yscale,oldRot[i],c_white,alpha);
	shader_reset();
}

var xscale = image_xscale,
	yscale = image_yscale;

var dist = clamp((point_distance(x,y,xstart,ystart) + 2 + sprite_xoffset)/projLength,0,1);
xscale = dist;
if(rFrame != 0)
{
	dist = clamp((lengthdir_x(point_distance(x,y,xstart,ystart) + 2,45) + sprite_xoffset)/projLength,0,1);
	xscale = dist;
	yscale = dist;
}

chameleon_set(sprt_HyperBeamPalette,obj_Display.hyperRainbowCycle,0,0,11);
draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),xscale,yscale,angle,c_white,image_alpha);
shader_reset();

if(fired < 4)
{
	var sSprt = sprt_HyperBeamStartParticle;
	firedFrame = scr_wrap(firedFrame+1,0,sprite_get_number(sSprt));
	firedFrameCounter = 0;
	
	if(firedFrame == sprite_get_number(sSprt)-1)
	{
		fired++;
	}
	
	var hObj = id;
	
	with(obj_Player)
	{
		chameleon_set(sprt_HyperBeamPalette,obj_Display.hyperRainbowCycle,0,0,11);
		draw_sprite_ext(sSprt,hObj.firedFrame,scr_round(shootPosX),scr_round(shootPosY),1,1,0,c_white,1);
		shader_reset();
		
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_HyperBeamStartParticle_Glow,hObj.firedFrame,scr_round(shootPosX),scr_round(shootPosY),1,1,0,c_white,0.75);
		gpu_set_blendmode(bm_normal);
	}
}

if(!global.gamePaused)
{
	for(var i = 10; i > 0; i--)
	{
		oldRot[i] = oldRot[i - 1];
	}
	oldRot[0] = angle;
}