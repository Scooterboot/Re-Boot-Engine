/// @description HUD Control
cHSelect = obj_Control.hSelect;
cHCancel = obj_Control.hCancel;
cHRight = obj_Control.right;
cHLeft = obj_Control.left;
cHUp = obj_Control.up;
cHDown = obj_Control.down;
cHToggle = obj_Control.mSelect;

var beamNum = (hasItem[Item.IceBeam]+hasItem[Item.WaveBeam]+hasItem[Item.Spazer]+hasItem[Item.PlasmaBeam]),
	itemNum = (item[Item.Missile]+item[Item.SuperMissile]+item[Item.PowerBomb]+item[Item.GrappleBeam]+item[Item.XRayVisor]);

if(!global.roomTrans && !obj_PauseMenu.pause)
{
	if(global.grappleAimAssist && state != State.Morph && item[Item.GrappleBeam] && hudSlot == 1 && hudSlotItem[1] == 3)
	{
		if(!instance_exists(grapReticle))
		{
			grapReticle = instance_create_depth(x,y,-4,obj_GrappleTargetAssist);
		}
	}
	else if(instance_exists(grapReticle))
	{
		instance_destroy(grapReticle);
	}
	
	if(global.HUD == 0)
	{
		hudSlotItem[0] = 0;
		moveHPrev = 1;
		pauseSelect = false;
		
		var itemAmmo = [ (item[Item.Missile] && missileStat > 0), (item[Item.SuperMissile] && superMissileStat > 0), (item[Item.PowerBomb] && powerBombStat > 0), item[Item.GrappleBeam], item[Item.XRayVisor] ];
		var itemNum2 = (itemAmmo[0] + itemAmmo[1] + itemAmmo[2] + itemAmmo[3] + itemAmmo[4]);
		
		if(itemNum2 > 0)
		{
			if(cHSelect && rHSelect)
			{
				if(hudSlot == 0)
				{
					hudSlot = 1;
				}
				else
				{
					hudSlotItem[1]++;
				}
				
				var numH = 5;
				while(!itemAmmo[scr_wrap(hudSlotItem[1], 0, 5)] && numH > 0)
				{
					hudSlotItem[1]++;
				}
				
				if(hudSlotItem[1] > 4)
				{
					hudSlot = 0;
					hudSlotItem[1] = 0;
				}
				
				audio_play_sound(snd_MenuTick,0,false);
			}
			else if(hudSlot == 1)
			{
				if(!itemAmmo[scr_wrap(hudSlotItem[1], 0, 5)])
				{
					if(hudSlotItem[1] == Item.Missile && itemAmmo[Item.SuperMissile])
					{
						hudSlotItem[1] = Item.SuperMissile;
					}
					else if(hudSlotItem[1] == Item.SuperMissile && itemAmmo[Item.Missile])
					{
						hudSlotItem[1] = Item.Missile;
					}
					else
					{
						hudSlot = 0;
						hudSlotItem[1] = 0;
					}
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			
			if(hudSlot == 1 && ((cHCancel && rHCancel) || hudSlotItem[1] > 4))
			{
				hudSlot = 0;
				hudSlotItem[1] = 0;
				if(cHCancel)
				{
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
		}
		else
		{
			hudSlot = 0;
			hudSlotItem[1] = 0;
		}
		
		if(hudSlot == 0)
		{
			hudSlotItem[1] = 0;
		}
	}
	else if(global.HUD == 1)
	{
		hudSlotItem[0] = 0;
		if(cHCancel && itemNum > 0)
		{
			if(cHCancel && rHCancel)
			{
				audio_play_sound(snd_MenuTick,0,false);
			}
			hudSlot = 1;
		}
		else
		{
			hudSlot = 0;
		}
		
		if(itemNum > 1)
		{
			if(cHSelect)
			{
				pauseSelect = true;
				global.gamePaused = true;
					
				moveH = (cHRight && rHRight) - (cHLeft && rHLeft);
				if(moveH != 0)
				{
					//hudBOffsetX = 28*moveH;
					//hudIOffsetX = 28*moveH;
					moveHPrev = moveH;
					audio_play_sound(snd_MenuTick,0,false);
				}
				hudSlotItem[1] += moveH;
			}
			else
			{
				moveHPrev = 1;
				if(!rHSelect)
				{
					global.gamePaused = false;
				}
				pauseSelect = false;
			}
		}
		else
		{
			pauseSelect = false;
		}
	}
	else if(global.HUD == 2)
	{
		if(cHCancel && rHCancel && itemNum > 0)
		{
			hudSlot = scr_wrap(hudSlot + 1, 0, 2);
			audio_play_sound(snd_MenuTick,0,false);
		}
		if(cHSelect)
		{
			global.gamePaused = true;
			/*if(((cHUp && rHUp) || (cHDown && rHDown)) && itemNum > 0)
			{
				hudSlot = scr_wrap(hudSlot + 1, 0, 1);
				audio_play_sound(snd_MenuTick,0,false);
			}*/
			if((hudSlot == 0 && beamNum > 0) || (hudSlot == 1 && itemNum > 1))
			{
				moveH = (cHRight && rHRight) - (cHLeft && rHLeft);
				if(moveH != 0)
				{
					hudBOffsetX = 28*moveH;
					hudIOffsetX = 28*moveH;
					moveHPrev = moveH;
					audio_play_sound(snd_MenuTick,0,false);
				}
				hudSlotItem[hudSlot] += moveH;
			}
			var hudSlotItem2 = scr_wrap(hudSlotItem[0], 1, 5);
			if(hudSlot == 0 && hudSlotItem[0] != 0)
			{
				if(cHToggle && rHToggle && hasItem[beamIndex[hudSlotItem2]])
				{
					item[beamIndex[hudSlotItem2]] = !item[beamIndex[hudSlotItem2]];
					audio_play_sound(snd_MenuShwsh,0,false);
				}
			}
		}
		else if(!rHSelect)
		{
			global.gamePaused = false;
		}
		pauseSelect = cHSelect;
	}
}

var numH = 5;
while(!hasItem[beamIndex[scr_wrap(hudSlotItem[0], 1, 5)]] && hudSlotItem[0] != 0 && numH > 0)
{
	hudSlotItem[0] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
numH = 5;
while(!item[equipIndex[scr_wrap(hudSlotItem[1], 0, 5)]] && numH > 0)
{
	hudSlotItem[1] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
for(var i = 0; i < array_length(hudSlotItem); i++)
{
	hudSlotItem[i] = scr_wrap(hudSlotItem[i], 0, 5);
}

rHSelect = !cHSelect;
rHCancel = !cHCancel;
rHRight = !cHRight;
rHLeft = !cHLeft;
rHUp = !cHUp;
rHDown = !cHDown;
rHToggle = !cHToggle;