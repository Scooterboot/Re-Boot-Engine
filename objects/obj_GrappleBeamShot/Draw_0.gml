image_speed = 0.5;

if(drawGrapEffect)
{
    draw_sprite_ext(sprite_index,image_index,scr_round(x),scr_round(y),1,1,0,c_white,1);
    grapFrame = scr_wrap(grapFrame - 0.5, 0, 3);
    draw_sprite_ext(sprt_GrappleBeamImpact,grapFrame,scr_round(x),scr_round(y),1,1,0,c_white,1);
}

drawGrapDelay = max(drawGrapDelay-1,0);

scr_DamageNPC(x,y,damage,damageType,0,-1,4);