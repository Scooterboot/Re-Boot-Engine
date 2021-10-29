/// @description Initialize
image_alpha = .8;//.75;
x = 0;

/// -- Create surface and redraw it --

/*Distortion = noone;
if (global.waterDistortion)
{
    Distortion = surface_create(surface_get_width(application_surface),surface_get_height(application_surface));
}*/
Distortion = surface_create(global.resWidth,global.resHeight);

// -- Is distortion enabled in the options?

Distort = true;//(oControl.DrawDistortion);
Index = 0;

/// -- Everything else.

Mode = bm_add;
Col = make_color_rgb(255,200,200);
Time = 0;

// -- Bobbing variables

acc = -.0125/4;     //-.0125/4;
bspd = -.05;         //-.1;
btm = .25;          //.25;

Move = 1;
MoveX = 0;

Gradient = instance_create_depth(x,y - 32,depth+10,obj_GradientCustom);
Gradient.Color = make_color_rgb(225,32,0);
Gradient.Height = 2.2;
Gradient.Alpha = 0.8;
//Gradient . depth = -241;