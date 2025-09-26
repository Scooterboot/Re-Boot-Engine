/// @description 

if(global.GamePaused())
{
    exit;
}

vel = max(vel-frict,0);
x += lengthdir_x(vel,ang);
y += lengthdir_y(vel,ang);

time++;
if(time > timeLeft)
{
	instance_destroy();
}