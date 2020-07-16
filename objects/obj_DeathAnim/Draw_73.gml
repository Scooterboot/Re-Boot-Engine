var vx = camera_get_view_x(view_camera[0]),
	vy = camera_get_view_y(view_camera[0]),
	vw = global.resWidth,
	vh = global.resHeight;

var destPosX = vw/2,
    destPosY = vh/2;

if(screenFade[0] >= 1)
{
    if(posX != destPosX || posY != destPosY)
    {
        var speedX = max(abs(destPosX - posX)*0.125,1);
        if(posX < destPosX)
        {
            posX = min(posX + speedX, destPosX);
        }
        else
        {
            posX = max(posX - speedX, destPosX);
        }
        
        var speedY = max(abs(posY - destPosY)*0.125,1);
        if(posY < destPosY)
        {
            posY = min(posY + speedY, destPosY);
        }
        else
        {
            posY = max(posY - speedY, destPosY);
        }
    }
}

draw_set_alpha(screenFade[0]);
draw_set_color(c_black);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

draw_set_alpha(screenFade[1]);
draw_set_color(c_white);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

var sIndex = sprt_DeathRight;
if(dir == -1)
{
    sIndex = sprt_DeathLeft;
}
draw_sprite_ext(sIndex,animSequence[frame],vx+posX,vy+posY,dir,1,0,c_white,screenFade[0]);

draw_set_alpha(screenFade[2]);
draw_set_color(c_black);
draw_rectangle(vx,vy,vx+vw,vy+vh,false);

draw_set_alpha(1);
draw_set_color(c_white);

if(frame > 12)
{
    screenFade[1] = min(screenFade[1] + 0.025, 1);
}
if(screenFade[1] >= 1 && frame >= array_length_1d(animSequence)-1)
{
    screenFade[2] = min(screenFade[2] + 0.025, 1);
}

screenFade[0] = min(screenFade[0] + 0.1, 1);
frameCounter++;
if(frameCounter > 2)
{
    frame = min(frame+1,array_length_1d(animSequence)-1);
    frameCounter = 0;
}

if(screenFade[0] >= 1)
{
    instance_destroy(obj_Player);
    instance_destroy(obj_Camera);
}
if(screenFade[2] >= 1 && !audio_is_playing(snd_Death))
{
    room_goto(rm_MainMenu);
    global.gamePaused = false;
    //game_restart();
    instance_destroy();
}