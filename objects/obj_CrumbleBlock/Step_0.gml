/// @description Crumble Logic
event_inherited();

if(instance_exists(obj_Player) && !obj_Player.spiderBall)
{
    if((obj_Player.fVelY >= 0 && place_meeting(x,y-(1+abs(obj_Player.fVelY)),obj_Player)) ||
    (obj_Player.state == State.Grip && (place_meeting(x-1,y,obj_Player) || place_meeting(x+1,y,obj_Player))))
    {
        crumble = true;
    }
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