/// -- Start -- 

//init_mask();
//change_mask(-1,-1,1,1,0,"");
water_init(0);

xVel = 0;
yVel = 0;

CanSpread = 1;
Breathed = 1;

Time = 0;

FadeIn = 0;

MaxSpeed = .5;
Delete = 0;

CanBubble = 0;

Spawned = 0;

Timer = 25 + random(40);
Index = irandom(4);

/// -- Visual

image_alpha = .833-random(.1);
Alpha = image_alpha;
AlphaMult = .9;
image_xscale = choose(.9,1,.8,.7);
image_yscale = image_xscale;