/// @description 
if(!instance_exists(obj_Camera))
{
	exit;
}

var camx = obj_Camera.playerXRayX - width/2, //camera_get_view_x(view_camera[0]),
	camy = obj_Camera.playerXRayY - height/2; //camera_get_view_y(view_camera[0]);

alpha = clamp(coneSpread/20,0,1);
darkAlpha = alpha*0.55;

visorX = x - camx;
visorY = y - camy;

// -- Keep the surfaces stable.

if !(surface_exists(surfaceFront))
{
    surfaceFront = surface_create(width,height);
    xray_redraw_front();
}
else if (refresh)
{
    xray_redraw_front();
}

if !(surface_exists(alphaMask))
{
    alphaMask = surface_create(width,height);
    xray_redraw_alpha();
}
else if (refresh)
{
    xray_redraw_alpha();
}

if !(surface_exists(breakMask))
{
    breakMask = surface_create(width,height);
    xray_redraw_break();
}
else if (refresh)
{
    xray_redraw_break();
}

if !(surface_exists(outlineSurf))
{
    outlineSurf = surface_create(width,height);
    xray_redraw_outline();
}
else if (refresh)
{
    xray_redraw_outline();
}

if !(surface_exists(outlineSurf2))
{
    outlineSurf2 = surface_create(width,height);
    xray_redraw_outline2();
}
else if (refresh)
{
    xray_redraw_outline2();
}

refresh = 0;

if !(surface_exists(alphaMaskTemp))
{
    alphaMaskTemp = surface_create(width,height);
}

if !(surface_exists(surfaceFrontTemp))
{
    surfaceFrontTemp = surface_create(width,height);
}

if !(surface_exists(breakMaskTemp))
{
    breakMaskTemp = surface_create(width,height);
}

if !(surface_exists(outlineSurfTemp))
{
    outlineSurfTemp = surface_create(width,height);
}


// AlphaMask

surface_set_target(alphaMaskTemp);
draw_clear_alpha(c_white,1);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglelist);
draw_vertex_colour(visorX,visorY,0,0);
draw_vertex_colour(visorX+lengthdir_x(coneLength,coneDir + coneSpread),visorY+lengthdir_y(coneLength,coneDir + coneSpread),0,0);
draw_vertex_colour(visorX+lengthdir_x(coneLength,coneDir - coneSpread),visorY+lengthdir_y(coneLength,coneDir - coneSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);

draw_surface(alphaMask,0,0);


surface_reset_target();

// First, Front

surface_set_target(surfaceFrontTemp);
draw_clear_alpha(0,0);
draw_surface(surfaceFront,0,0);
//gpu_set_blendmode_ext(6,3);
gpu_set_blendmode_ext(bm_inv_src_alpha, bm_src_colour);
gpu_set_colorwriteenable(0,0,0,1);
draw_surface(alphaMaskTemp,0,0);
gpu_set_colorwriteenable(1,1,1,1);
gpu_set_blendmode(bm_normal);
surface_reset_target();

// Second, breakables

surface_set_target(breakMaskTemp);
draw_clear_alpha(0,0);

draw_surface(breakMask,0,0);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglestrip);
for(var i = 0; i < 360-(coneSpread*2); i = min(i+45,360-(coneSpread*2)))
{
    var dir = coneDir + coneSpread + i;
    draw_vertex_colour(visorX,visorY,0,0);
    draw_vertex_colour(visorX+lengthdir_x(coneLength,dir),visorY+lengthdir_y(coneLength,dir),0,0);
}
draw_vertex_colour(visorX,visorY,0,0);
draw_vertex_colour(visorX+lengthdir_x(coneLength,coneDir - coneSpread),visorY+lengthdir_y(coneLength,coneDir - coneSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);
surface_reset_target();

// Third, outlines

surface_set_target(outlineSurfTemp);
draw_clear_alpha(0,0);


gpu_set_colorwriteenable(0,0,0,1);

var radius = 25;
var totRadius = width+(radius*2);
outlineFlash = scr_wrap(outlineFlash + 1.25, 0, totRadius);

for(var i = -radius; i < radius; i += 0.75)
{
	var rad = scr_wrap(outlineFlash + i, 0, totRadius);
	
	draw_set_color(c_white);
	var alph = clamp(lerp(1, 0, (abs(i)/radius)), 0, 1);
	draw_set_alpha(alph);
	
	var num = 4;
	for(var j = 0; j < num; j++)
	{
		var rad2 = scr_wrap(rad + scr_floor(totRadius/num)*j,0,totRadius);
		draw_circle(visorX,visorY,rad2,true);
	}
	
	draw_set_alpha(1);
}

gpu_set_colorwriteenable(1,1,1,0);
draw_surface(outlineSurf2,0,0);
gpu_set_colorwriteenable(1,1,1,1);

gpu_set_blendmode_ext(bm_dest_alpha, bm_src_alpha);

draw_primitive_begin(pr_trianglestrip);
for(var i = 0; i < 360-(coneSpread*2); i = min(i+45,360-(coneSpread*2)))
{
    var dir = coneDir + coneSpread + i;
    draw_vertex_colour(visorX,visorY,0,0);
    draw_vertex_colour(visorX+lengthdir_x(coneLength,dir),visorY+lengthdir_y(coneLength,dir),0,0);
}
draw_vertex_colour(visorX,visorY,0,0);
draw_vertex_colour(visorX+lengthdir_x(coneLength,coneDir - coneSpread),visorY+lengthdir_y(coneLength,coneDir - coneSpread),0,0);
draw_primitive_end();

gpu_set_blendmode(bm_normal);
surface_reset_target();


// Draw surfaces

draw_surface(surfaceFrontTemp,camx,camy);
draw_surface(breakMaskTemp,camx,camy);

gpu_set_blendmode(bm_add);
draw_surface_ext(outlineSurfTemp,camx,camy,1,1,0,c_ltgray,darkAlpha);
gpu_set_blendmode(bm_normal);


visorX = x;
visorY = y;

// Check obj_TileFadeHandler for additional code related to XRay