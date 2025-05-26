destX = scr_round(obj_Player.x+obj_Player.sprtOffsetX+obj_Player.armOffsetX);
destY = scr_round(obj_Player.y+obj_Player.sprtOffsetY+obj_Player.armOffsetY+obj_Player.runYOffset);
speed = 0;
direction = 0;

vel = random_range(2,5);
ang = point_direction(x,y,destX,destY);

time = 0;
totalTime = (point_distance(x,y,destX,destY)/vel)*1.25;

alpha = 0;
initDist = point_distance(x,y,destX,destY);

prevDestX = destX;
prevDestY = destY;

color1 = c_white;
color2 = c_white;
color3 = c_white;