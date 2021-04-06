/// -- Fade Away

if(global.gamePaused)
{
	exit;
}

/// -- Fade

x += xVel;
y += yVel;

image_alpha -= Speed;

if (image_alpha <= 0)
{
	instance_destroy();
}