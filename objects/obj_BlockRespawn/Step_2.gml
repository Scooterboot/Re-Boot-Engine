/// @description Timer
if(global.gamePaused)
{
    exit;
}

if(respawnTime <= 9)
{
    visible = true;
    image_index = (clamp(ceil(respawnTime/3),0,3)-1);
}
else
{
    visible = false;
}


if(respawnTime <= 0)
{
    instance_destroy();
}

if((place_meeting(x,y,obj_Player) || place_meeting(x,y,obj_PushBlock)) && respawnTime <= 30)
{
    respawnTime = min(respawnTime + 1, 30);
}
else
{
    respawnTime = max(respawnTime - 1, 0);
}