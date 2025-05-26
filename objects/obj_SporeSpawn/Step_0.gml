/// @description 
event_inherited();
if(PauseAI())
{
	exit;
}

phase = 0;
//if(life < 770)
if(life < lifeMax*0.8)
{
	phase = 1;
}
//if(life < 410)
if(life < lifeMax*0.43)
{
	phase = 2;
}
//if(life < 70)
if(life < lifeMax*0.073)
{
	phase = 3;
}
if(life <= 0 || dead)
{
	phase = 4;
}

if(ai[0] == 0)
{
	ai[1]++;
	if(ai[1] > 60)
	{
		position.Y = min(position.Y + 1, patternCenter.Y);
	}
	
	if(position.Y >= patternCenter.Y)
	{
		ai[0] = 1;
		ai[1] = 0;
	}
}
else if(ai[0] < 3)
{
	if(ai[0] == 1)
	{
		var spd = moveAngleSpd*moveDir;
		//if(life < 400)
		if(life < lifeMax*0.417)
		{
			spd *= 2;
		}
		moveAngle += spd;
		
		mouthOpen = false;
		
		ai[1]++;
		var thresh = 840;
		if(ai[1] > thresh-30)
		{
			mouthOpen = true;
		}
		if(ai[1] > thresh && image_yscale >= 1)
		{
			ai[0] = 2;
			ai[1] = 0;
		}
	}
	if(ai[0] == 2)
	{
		mouthOpen = true;
		
		ai[1]++;
		if(ai[1] > 240)
		{
			mouthOpen = false;
			if(image_yscale <= 0)
			{
				ai[0] = 1;
				ai[1] = 0;
			}
		}
	}
	
	position.X = patternCenter.X + moveRadiusX * dcos(moveAngle);
	position.Y = patternCenter.Y - moveRadiusY * dsin(moveAngle * 2);
}

x = scr_round(position.X);
y = scr_round(position.Y);

if(mouthOpen)
{
	image_yscale = min(image_yscale + 2/height, 1);
}
else
{
	image_yscale = max(image_yscale - 1.5/height, 0);
}

if(instance_exists(mouthTop))
{
	mouthTop.x = x;
	mouthTop.y = bbox_top;
}
else
{
	mouthTop = instance_create_layer(x,bbox_top,layer,obj_SporeSpawn_Top);
	mouthTop.realLife = id;
	mouthTop.life = life;
	mouthTop.lifeMax = lifeMax;
	mouthTop.damage = damage;
}

if(instance_exists(mouthBottom))
{
	mouthBottom.x = x;
	mouthBottom.y = bbox_bottom;
}
else
{
	mouthBottom = instance_create_layer(x,bbox_bottom,layer,obj_SporeSpawn_Bottom);
	mouthBottom.realLife = id;
	mouthBottom.life = life;
	mouthBottom.lifeMax = lifeMax;
	mouthBottom.damage = damage;
}

coreFrameCounter++;
if(coreFrameCounter > 6)
{
	coreFrame = scr_wrap(coreFrame+1,0,4);
	coreFrameCounter = 0;
}