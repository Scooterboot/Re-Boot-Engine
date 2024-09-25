/// @description Crumble Logic
event_inherited();

if(global.gamePaused)
{
	exit;
}

var player = instance_place(x,y-2,obj_Player);
if(instance_exists(player) && player.fVelY >= 0 && !player.spiderBall)
{
	crumble = true;
	if(abs(player.velX) > player.maxSpeed[5,player.liquidState])
	{
		timeLeft = 4; // yes im actually doing this
	}
}

player = instance_place(x+1,y,obj_Player);
if(!instance_exists(player))
{
	player = instance_place(x-1,y,obj_Player);
}
if(instance_exists(player) && player.state == State.Grip && player.bb_top() >= bbox_top)
{
	crumble = true;
}

var pushBlock = instance_place(x,y-1,obj_PushBlock);
if(instance_exists(pushBlock) && pushBlock.grounded && pushBlock.fVelY >= 0)
{
	crumble = true;
}

if(crumble)
{
    if(time >= timeLeft)
    {
        instance_destroy();
    }
    time += 1;
}