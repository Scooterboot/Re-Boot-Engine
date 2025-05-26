/// @description 
event_inherited();

if(PauseAI())
{
    exit;
}

var playerDetected = false;
if(state != PirateState.Turn)
{
    var xplus = 0;
    var num = 10;
    while(!collision_rectangle(max(bb_left()+xplus,bb_left()),bb_top(),min(bb_right()+xplus,bb_right()),bb_bottom()-16,solids,false,true) && num > 0)
    {
        xplus += 16*dir;
        num--;
    }
    if(collision_rectangle(max(bb_left()+xplus,bb_left()),bb_top(),min(bb_right()+xplus,bb_right()),bb_bottom()-16,obj_Player,false,true))
    {
        playerDetected = true;
    }
}
if(playerDetected)
{
    state = PirateState.Shoot;
}

if(state == PirateState.Stand)
{
    velX = 0;
    
    var counterMax = 2;
    if(frame[0] == 0)
    {
        counterMax = 10;
    }
    if(frame[0] == 2 || frame[0] == 6)
    {
        counterMax = 60;
    }
    frameCounter[0]++;
    if(frameCounter[0] > counterMax)
    {
        frame[0]++;// = scr_Loop(frame[0]+1,0,7);
        frameCounter[0] = 0;
    }
    currentSprt = sprtStand;
    currentFrame = standFrameSequence[min(frame[0],8)];
    
    if(frame[0] > 8)
    {
        state = PirateState.Turn;
        currentSprt = sprtTurn;
        currentFrame = 0;
    }
}
else
{
    frame[0] = 0;
    frameCounter[0] = 0;
}

if(state == PirateState.Turn)
{
    velX = 0;
    
    frameCounter[1]++;
    if(frameCounter[1] > 2)
    {
        frame[1]++;
        frameCounter[1] = 0;
    }
    currentSprt = sprtTurn;
    currentFrame = frame[1];
    if(frame[1] > 2)
    {
        state = PirateState.Run;
        dir *= -1;
        currentSprt = sprtRun;
        currentFrame = 0;
    }
}
else
{
    frame[1] = 0;
    frameCounter[1] = 0;
}

if(state == PirateState.Run)
{
    velX = moveSpeed*dir;
    
    frameCounter[2]++;
    if(frameCounter[2] > 3)
    {
		var animSp = moveSpeed;
        frame[2] = scr_wrap(frame[2]+animSp,0,16);
        frameCounter[2] = 0;
    }
    currentSprt = sprtRun;
    currentFrame = scr_round(frame[2]);
    
    runCounter++;
    
    var num2 = 0;
    while(entity_place_collide(num2*sign(velX),1) && num2 <= abs(velX))
    {
        num2 = min(num2 + 1, abs(velX)+1);
    }
    
    if(entity_place_collide(sign(velX),-3))
    {
        state = PirateState.Turn;
        currentSprt = sprtTurn;
        currentFrame = 0;
    }
    else if(runCounter > 90 || !entity_place_collide(num2*sign(velX),4))
    {
        state = PirateState.Stand;
        currentSprt = sprtStand;
        currentFrame = 2;
        velX = 0;
    }
}
else
{
    if(state != PirateState.Shoot)
    {
        runCounter = 0;
    }
    frame[2] = 0;
    frameCounter[2] = 0;
}

if(state == PirateState.Shoot)
{
    velX = 0;
    
    if(frame[3] < 4 || shotsFired)
	{
		frameCounter[3]++;
	    if(frameCounter[3] > 4)
	    {
	        frame[3]++;
	        frameCounter[3] = 0;
			if(frame[3] == 6)
			{
				frameCounter[3] = -4;
			}
	    }
	}
	else if(!shotsFired)
	{
		var sX,sY;
		sX[0] = -1*dir;
		sY[0] = 8;
		sX[1] = 11*dir;
		sY[1] = 1;
		
		for(var i = 0; i < 2; i++)
		{
			var dpth = depth-1;
			if(i == 1)
			{
				dpth = depth+1;
			}
			var shot = instance_create_depth(x+sX[i],y+sY[i],dpth,obj_PirateBeam);
	        shot.damage = damage;
	        shot.velX = 4*dir;
	        shot.direction = 0;
	        if(dir == -1)
	        {
	            shot.direction = 180;
	        }
	        shot.creator = id;
			shot.xstart = shot.x;
			shot.ystart = shot.y;
			
			part_particles_create(obj_Particles.partSystemA,x+sX[i],y+sY[i],obj_Particles.mFlare[0],1);
		}
		
		audio_stop_sound(snd_SpacePirate_Shoot);
		audio_play_sound(snd_SpacePirate_Shoot,0,false);
		
		shotsFired = true;
		frameCounter[3] = 5;
	}
	
    currentSprt = sprtShoot;
    currentFrame = shootFrameSequence[min(frame[3],10)];
	
	if(frame[3] > 10)
    {
        state = prevState;
        frame[3] = 0;
        frameCounter[3] = 0;
		shotsFired = false;
    }
}
else
{
    prevState = state;
    frame[3] = 0;
    frameCounter[3] = 0;
	shotsFired = false;
}

grounded = (entity_place_collide(0,1) || (bb_bottom()+1) >= room_height);// && velY == 0);
fGrav = grav[instance_exists(liquid)];

if(!grounded)
{
    velY = min(velY+fGrav, maxGrav);
}

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,true);

EntityLiquid_Large(x-xprevious,y-yprevious);