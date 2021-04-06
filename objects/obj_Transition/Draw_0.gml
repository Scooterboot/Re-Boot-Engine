if(surface_exists(transSurf))
{
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    if(transSprtDraw)
    {
        with(obj_Player)
        {
            PreDrawPlayer(obj_Transition.samusX,obj_Transition.samusY,0,1);
            pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
            DrawPlayer(obj_Transition.samusX,obj_Transition.samusY,rotation,1);
            shader_reset();
            PostDrawPlayer(obj_Transition.samusX,obj_Transition.samusY,0,1);
            water_init(0);
        }
    }
    surface_reset_target();

    draw_surface_ext(transSurf,camera_get_view_x(view_camera[0]),camera_get_view_y(view_camera[0]),1,1,0,c_white,alpha);
}
else
{
    transSurf = surface_create(global.resWidth,global.resHeight);
    surface_set_target(transSurf);
    draw_clear_alpha(c_black,1);
    surface_reset_target();
}