

draw_self();
grapFrame = scr_wrap(grapFrame - 0.5, 0, 4);
draw_sprite_ext(sprt_GravGrappleImpact,grapFrame,scr_round(x),scr_round(y),1,1,0,c_white,1);

/*
var player = creator;
gunX = player.shootPosX - player.x;
gunY = player.shootPosY - player.y;

aRot -= 0.05;
//var cap = min(point_distance(x,y, player.shootPosX,player.shootPosY)*1.5, 100.0);
var cap = min(point_distance(x,y, player.shootPosX,player.shootPosY)*2, 500.0);

var dx, dy, prec, iprec;
for(var i = 0.0; i < cap; i += 1.0)
{
	prec = i/cap;
	iprec = 1.0 - prec;
	
	dx = (distTargetX*prec)*prec + (animX*prec + gunX)*iprec + player.x;
	dy = (distTargetY*prec)*prec + (animY*prec + gunY)*iprec + player.y;
	
	//self.DrawBit(dx, dy, aRot + (i/100.0)*4.0, self.GetScale(prec*2.0), sin(aRot*3.0+prec*4.0)/4.0 + 0.75);
	self.DrawBit(dx, dy, aRot + prec*4.0, self.GetScale(prec*2.0), sin(aRot*3.0+prec*4.0)/4.0 + 0.75);
}

draw_sprite_ext(sprt_GrappleBeamEnd,0, x,y, 1,1,0,c_white,1);
*/