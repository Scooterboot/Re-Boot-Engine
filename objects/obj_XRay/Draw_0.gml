/// @description Draw the fuckin' magic...
var camx = camera_get_view_x(view_camera[0]),
	camy = camera_get_view_y(view_camera[0]);
if !(Die)
{
    //ConeSpread = min(ConeSpread + 1, 15);
	ConeSpread = min(ConeSpread + 2, 30);
    //Alpha = min(Alpha + .066667, 1);
}
else
{
    ConeSpread = max(ConeSpread - 2, 0);
    //Alpha = max(Alpha - .13334, 0);
    
    if (ConeSpread <= 0)
    {
        instance_destroy();
    }
}
Alpha = clamp(ConeSpread/20,0,1);
DarkAlpha = Alpha*0.55;

VisorX = x - camx;
VisorY = y - camy;

// -- Keep the surfaces stable.

if !(surface_exists(SurfaceFront))
{
    SurfaceFront = surface_create(Width,Height);
    xray_redraw_front();
}
else if (RefreshThisFrame)
{
    xray_redraw_front();
}

if !(surface_exists(AlphaMask))
{
    AlphaMask = surface_create(Width,Height);
    xray_redraw_alpha();
}
else if (RefreshThisFrame)
{
    xray_redraw_alpha();
}

if !(surface_exists(BreakMask))
{
    BreakMask = surface_create(Width,Height);
    xray_redraw_break();
}
else if (RefreshThisFrame)
{
    xray_redraw_break();
}

if !(surface_exists(OutlineSurf))
{
    OutlineSurf = surface_create(Width,Height);
    xray_redraw_outline();
}
else if (RefreshThisFrame)
{
    xray_redraw_outline();
}

if !(surface_exists(OutlineSurf2))
{
    OutlineSurf2 = surface_create(Width,Height);
    xray_redraw_outline2();
}
else //if (RefreshThisFrame)
{
    xray_redraw_outline2();
}

RefreshThisFrame = 0;

if !(surface_exists(AlphaMaskTemp))
{
    AlphaMaskTemp = surface_create(Width,Height);
}

if !(surface_exists(SurfaceFrontTemp))
{
    SurfaceFrontTemp = surface_create(Width,Height);
}

if !(surface_exists(BreakMaskTemp))
{
    BreakMaskTemp = surface_create(Width,Height);
}

if !(surface_exists(OutlineSurfTemp))
{
    OutlineSurfTemp = surface_create(Width,Height);
}


// -- AlphaMask Figureout

surface_set_target(AlphaMaskTemp);
draw_clear_alpha(c_white,1);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglelist);
draw_vertex_colour(VisorX,VisorY,0,0);
draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir + ConeSpread),VisorY+lengthdir_y(500,ConeDir + ConeSpread),0,0);
draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);

draw_surface(AlphaMask,0,0);


surface_reset_target();

// -- First, Front

surface_set_target(SurfaceFrontTemp);
draw_clear_alpha(0,0);
draw_surface(SurfaceFront,0,0);
gpu_set_blendmode_ext(6,3);
gpu_set_colorwriteenable(0,0,0,1);
draw_surface(AlphaMaskTemp,0,0);
gpu_set_colorwriteenable(1,1,1,1);
gpu_set_blendmode(bm_normal);
surface_reset_target();

// -- Second, breakables

surface_set_target(BreakMaskTemp);
draw_clear_alpha(0,0);

draw_surface(BreakMask,0,0);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglestrip);
for(var i = 0; i < 360-(ConeSpread*2); i = min(i+45,360-(ConeSpread*2)))
{
    var Dar = ConeDir + ConeSpread + i;
    draw_vertex_colour(VisorX,VisorY,0,0);
    draw_vertex_colour(VisorX+lengthdir_x(500,Dar),VisorY+lengthdir_y(500,Dar),0,0);
}
draw_vertex_colour(VisorX,VisorY,0,0);
draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);
surface_reset_target();

// -- Third, outlines

surface_set_target(OutlineSurfTemp);
draw_clear_alpha(0,0);


gpu_set_colorwriteenable(0,0,0,1);

var radius = 25;
var totRadius = Width+(radius*2);
outlineFlash = scr_wrap(outlineFlash + 1.25, 0, totRadius);

for(var i = -radius; i < radius; i += 0.75)
{
	var rad = scr_wrap(outlineFlash + i, 0, totRadius);
	
	draw_set_color(c_white);
	//draw_set_alpha(lerp(1,0.25,(abs(i)/radius)));
	var alph = clamp(lerp(1, 0, (abs(i)/radius)), 0, 1);
	draw_set_alpha(alph);
	
	var num = 4;
	for(var j = 0; j < num; j++)
	{
		var rad2 = scr_wrap(rad + scr_floor(totRadius/num)*j,0,totRadius);
		draw_circle(VisorX,VisorY,rad2,true);
	}
	
	draw_set_alpha(1);
}

gpu_set_colorwriteenable(1,1,1,0);
draw_surface(OutlineSurf2,0,0);
gpu_set_colorwriteenable(1,1,1,1);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglestrip);
for(var i = 0; i < 360-(ConeSpread*2); i = min(i+45,360-(ConeSpread*2)))
{
    var Dar = ConeDir + ConeSpread + i;
    draw_vertex_colour(VisorX,VisorY,0,0);
    draw_vertex_colour(VisorX+lengthdir_x(500,Dar),VisorY+lengthdir_y(500,Dar),0,0);
}
draw_vertex_colour(VisorX,VisorY,0,0);
draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);
surface_reset_target();


// -- Draw surfaces. Finally.

draw_surface(SurfaceFrontTemp,camx,camy);
draw_surface(BreakMaskTemp,camx,camy);

//oColorHue = scr_wrap(oColorHue+0.5,0,256);
//var cOutline = make_color_hsv(oColorHue,255,255);
gpu_set_blendmode(bm_add);
draw_surface_ext(OutlineSurfTemp,camx,camy,1,1,0,c_ltgray,DarkAlpha);
gpu_set_blendmode(bm_normal);

// -- Draw Dark Cover

VisorX = x;
VisorY = y;

/*draw_primitive_begin(pr_trianglestrip);
for(var i = 0; i < 360-(ConeSpread*2); i = min(i+45,360-(ConeSpread*2)))
{
    var Dar = ConeDir + ConeSpread + i;
    draw_vertex_colour(VisorX,VisorY,0,DarkAlpha);
    draw_vertex_colour(VisorX+lengthdir_x(500,Dar),VisorY+lengthdir_y(500,Dar),0,DarkAlpha);
}
draw_vertex_colour(VisorX,VisorY,0,DarkAlpha);
draw_vertex_colour(VisorX+lengthdir_x(500,ConeDir - ConeSpread),VisorY+lengthdir_y(500,ConeDir - ConeSpread),0,DarkAlpha);
draw_primitive_end();

with(obj_Player)
{
    if(instance_exists(obj_XRay))
    {
        gpu_set_blendmode(bm_add);
        pal_swap_set(pal_XRay_Visor,1+xRayVisorFlash,0,0,false);
		DrawPlayer(x,y,rotation,obj_XRay.Alpha);
        shader_reset();
        gpu_set_blendmode(bm_normal);
    }
}*/

// ^ This section of code was moved into obj_TileFadeHandler