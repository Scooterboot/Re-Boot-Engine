/// @description scr_PlasmaDraw(x,y,xscale,yscale,rotation,alpha,overrideOldPositons=false)
/// @param x
/// @param y
/// @param xscale
/// @param yscale
/// @param rotation
/// @param alpha
/// @param overrideOldPositons = false
function scr_PlasmaDraw() {

	var x1 = argument[0],
	y1 = argument[1],
	xscale = argument[2],
	yscale = argument[3],
	rot = argument[4],
	alpha = argument[5];

	if(!global.gamePaused)// && string_count("Plasma",object_get_name(object_index)) <= 0)
	{
	    xstart += speed_x;
	    ystart += speed_y;
	}

	var width = sprite_width,
	    height = sprite_height;
	var dist = clamp((point_distance(x1,y1,xstart,ystart) + 2 + 6*isMissile)/width,0,1);
	if(dist < 1 && argument_count >= 7 && argument[6])
	{
	    for(var i = 0; i < 11; i++)
	    {
	        oldPosX[i] = x;
	        oldPosY[i] = y;
	    }
	    for(var i = 0; i < 11; i++)
	    {
	        oldRot[i] = image_angle;
	    }
	}
	var w = floor(width*dist);

	var xoff = sprite_xoffset - (width-w),
	    yoff = sprite_yoffset + (dir == 1 && sprite_yoffset != scr_round(height/2) && !isMissile);
	var x2 = scr_round(x1) - (dcos(rot)*xoff + dsin(rot)*yoff)*xscale,
	    y2 = scr_round(y1) - (dcos(rot)*yoff - dsin(rot)*xoff)*yscale;

	var c = c_white;
	if(dist < 1 && !isMissile)
	{
	    draw_sprite_general(sprite_index,image_index,0,0,4,height,x2-lengthdir_x(4,rot),y2-lengthdir_y(4,rot),xscale,yscale,rot,c,c,c,c,alpha);
	}
	draw_sprite_general(sprite_index,image_index,(width-w),0,w,height,x2,y2,xscale,yscale,rot,c,c,c,c,alpha);


}
