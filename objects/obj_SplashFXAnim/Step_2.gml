/// @description Update

if(global.GamePaused())
{
	exit;
}
if(!instance_exists(liquid))
{
	instance_destroy();
	exit;
}

mask_index = sprite_index;

if(!initIndex)
{
	newIndex = image_index;
	prevIndex = floor(image_index);
	
	ogScaleX = image_xscale;
	ogRight = abs(bbox_right-x);
	ogLeft = abs(x-bbox_left);
	
	initIndex = true;
}

fVelX = 0;
if(sprite_index == sprt_WaterSplash && prevIndex != floor(image_index))
{
	fVelX += waterSplashMoveX[floor(image_index)] * sign(image_xscale);
	prevIndex = floor(image_index);
}

y += velY;
if(liquid.liquidType == LiquidType.Lava)
{
	fVelX += velX * 0.75;
	newIndex += animSpeed * 0.75;
}
else
{
	fVelX += velX;
	newIndex += animSpeed;
}

x += fVelX;
x = clamp(x,liquid.bbox_left,liquid.bbox_right);

//if(sprite_index == sprt_WaterSplash)
//{
	var liqEdge = liquid.bbox_right+6;
	if(sprite_index == sprt_WaterSplash)
	{
		liqEdge = liquid.bbox_right+2;
	}
	if((sign(image_xscale) > 0 || sprite_index != sprt_WaterSplash) && bbox_right > liqEdge)
	{
		var newRight = abs(liqEdge-x);
		image_xscale = ogScaleX * (newRight / ogRight);
	}
	
	liqEdge = liquid.bbox_left-6;
	if(sprite_index == sprt_WaterSplash)
	{
		liqEdge = liquid.bbox_left-2;
	}
	if((sign(image_xscale) < 0 || sprite_index != sprt_WaterSplash) && bbox_left < liqEdge)
	{
		var newLeft = abs(x-liqEdge);
		image_xscale = ogScaleX * (newLeft / ogLeft);
	}
//}

if(newIndex >= image_number)
{
	instance_destroy();
}

image_index = newIndex;

if (watery)
{
	y = scr_round(liquid.bbox_top);
	var ly = liquid.y - liquid.yprevious;
	if(ly > 0)
	{
		y = scr_round(liquid.bbox_top+ly);
	}
}