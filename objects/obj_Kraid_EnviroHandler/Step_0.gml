/// @description 
if(global.gamePaused)
{
	exit;
}

if(state == 1) // spawn start
{
	if(counter[1] > 0)
	{
		counter[1]--;
		
		if((counter[1] % 5) == 0)
		{
			audio_stop_sound(snd_BlockBreakHeavy);
			audio_play_sound(snd_BlockBreakHeavy,0,false);
		}
		if((counter[1] % 2) == 0)
		{
			var partX = irandom_range(partAreaX1,partAreaX2),
				partY = irandom_range(partAreaY1,partAreaY2);
			for(var i = 0; i < irandom_range(3,5); i++)
			{
				var partX2 = partX + irandom_range(-16,16),
					partY2 = partY + irandom_range(-16,16);
				part_particles_create(obj_Particles.partSystemA,partX2,partY2,obj_Particles.lDust[0],1);
			}
			
			if(counter[1] > 30)
			{
				var rock = instance_create_layer(partX,partY,"Projectiles",obj_Kraid_Rock);
				rock.sprite_index = choose(sprt_Kraid_Rock,sprt_Kraid_Pebble);
				rock.mask_index = rock.sprite_index;
				rock.velX = random_range(-1.5,1.5);
				rock.velY = -random_range(2,4);
			}
		}
	}
	else
	{
		state = 2;
		counter[0] = 0;
		counter[1] = 0;
	}
}
if(state == 2) // spawn end
{
	
}

if(state > 2)
{
	instance_destroy(camTile1);
	instance_destroy(camTile2);
}

if(state == 3) // second phase start
{
	counter[0]++;
	if(counter[0] > 20 && ds_list_size(phase2Blocks) > 0)
	{
		var i = irandom(ds_list_size(phase2Blocks)-1);
		
		var p2Block = phase2Blocks[| i];
		
		var rockX = p2Block.x+8,
			rockY = p2Block.y+8,
			rockSprt = choose(sprt_Kraid_Rock,sprt_Kraid_Pebble),
			amt = 1;
		
		if(rockSprt == sprt_Kraid_Pebble)
		{
			rockX += irandom_range(-3,3);
			rockY += irandom_range(-3,3);
			amt = 3;
		}
		
		for(var j = 0; j < amt; j++)
		{
			var rock = instance_create_layer(rockX,rockY,"Projectiles",obj_Kraid_Rock);
			rock.sprite_index = rockSprt;
			rock.mask_index = rockSprt;
			rock.velX = random_range(-0.5,0.5);
			rock.velY = random_range(-0.6,0);
		}
		
		instance_destroy(p2Block);
		ds_list_delete(phase2Blocks, i);
		
		counter[0] = 18;
	}
	else if(ds_list_size(phase2Blocks) <= 0)
	{
		bgAlpha = min(bgAlpha+0.025,1);
	}
	
	if(counter[1] > 0)
	{
		counter[1]--;
		
		if((counter[1] % 5) == 0)
		{
			audio_stop_sound(snd_BlockBreakHeavy);
			audio_play_sound(snd_BlockBreakHeavy,0,false);
		}
		if((counter[1] % 2) == 0)
		{
			var partX = irandom_range(partAreaX1,partAreaX2),
				partY = irandom_range(partAreaY1,partAreaY2);
			for(var i = 0; i < irandom_range(3,5); i++)
			{
				var partX2 = partX + irandom_range(-16,16),
					partY2 = partY + irandom_range(-16,16);
				part_particles_create(obj_Particles.partSystemA,partX2,partY2,obj_Particles.lDust[0],1);
			}
			
			if(counter[1] > 30)
			{
				var rock = instance_create_layer(partX,partY,"Projectiles",obj_Kraid_Rock);
				rock.sprite_index = choose(sprt_Kraid_Rock,sprt_Kraid_Pebble);
				rock.mask_index = rock.sprite_index;
				rock.velX = random_range(-1.5,1.5);
				rock.velY = -random_range(2,4);
			}
		}
	}
	else
	{
		state = 4;
		counter[0] = 0;
		counter[1] = 0;
	}
}
if(state == 4) // second phase end
{
	bgAlpha = min(bgAlpha+0.025,1);
}

if(state == 5) // death start
{
	for(var i = 0; i < ds_list_size(phase2Blocks); i++)
	{
		instance_destroy(phase2Blocks[| i]);
	}
	for(var i = 0; i < array_length(remainingBlocks); i++)
	{
		instance_destroy(remainingBlocks[i]);
	}

	counter[0]++;
	if(counter[0] > 10 && ds_list_size(spikes) > 0)
	{
		instance_destroy(spikes[| 0]);
		ds_list_delete(spikes, 0);
		
		counter[0] = 0;
	}
	
	if(counter[1] > 0)
	{
		counter[1]--;
		
		
	}
	else if(ds_list_size(spikes) <= 0)
	{
		state = 6;
		counter[0] = 0;
		counter[1] = 0;
	}
	
	bgAlpha = max(bgAlpha-0.1,0);
}
if(state == 6) // death end
{
	bgAlpha = min(bgAlpha+0.025,1);
	if(bgAlpha >= 1)
	{
		instance_destroy();
	}
}

var bgCol = make_color_rgb(255*bgAlpha,255*bgAlpha,255*bgAlpha);
layer_background_blend(layer_background_get_id(layer_get_id("Background")),bgCol);