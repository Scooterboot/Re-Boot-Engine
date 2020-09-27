/// @description Debug

var debug = false;
if(debug)
{
    if(instance_exists(obj_Tile))
    {
        obj_Tile.visible = true;
    }
    if(instance_exists(obj_Slope))
    {
        obj_Slope.visible = true;
    }
    if(instance_exists(obj_Platform))
    {
        obj_Platform.visible = true;
    }
    if(instance_exists(obj_Door))
    {
        obj_Door.visible = true;
    }
    with(obj_Player)
    {
        draw_set_color(c_red);
        draw_set_alpha(0.75);
        
        //draw_rectangle(x+6*dir,y+11,x+19*dir,y+24,0);
        //draw_rectangle(x+6*dir,y-5,x+19*dir,y+8,0);
        //draw_rectangle(x+6*dir,y-21,x+19*dir,y-8,0);
        //draw_rectangle(x+6*dir,y-37,x+19*dir,y-24,0);
        
        draw_rectangle(scr_round(bbox_left),scr_round(bbox_top),scr_round(bbox_right),scr_round(bbox_bottom),0);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
		
		var xx = camera_get_view_x(view_camera[0]),
			yy = camera_get_view_y(view_camera[0]);
		
        draw_set_font(MenuFont2);
        draw_text_transformed(xx+10,yy+40,"state: "+string(state),1,1,0);
        draw_text_transformed(xx+10,yy+50,"stateFrame: "+string(stateFrame),1,1,0);
        draw_text_transformed(xx+10,yy+60,"lastState: "+string(lastState),1,1,0);
        draw_text_transformed(xx+10,yy+70,"velX: "+string(velX),1,1,0);
        draw_text_transformed(xx+10,yy+80,"velY: "+string(velY),1,1,0);
    }
}

show_debug_message("delta_time: "+string(delta_time));