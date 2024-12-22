if(global.gamePaused)
{
    exit;
}

destX = scr_round(obj_Player.x+obj_Player.sprtOffsetX+obj_Player.armOffsetX);
destY = scr_round(obj_Player.y+obj_Player.sprtOffsetY+obj_Player.armOffsetY+obj_Player.runYOffset);

var xSpeed = (destX - prevDestX)*0.5;
var ySpeed = (destY - prevDestY)*0.5;

ang = point_direction(x,y,destX,destY);
x += lengthdir_x(vel,ang) + xSpeed;
y += lengthdir_y(vel,ang) + ySpeed;

time += 1;
if(time > totalTime || point_distance(x,y,destX,destY) <= 4)
{
    instance_destroy();
}

prevDestX = destX;
prevDestY = destY;