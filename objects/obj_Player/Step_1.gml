/// @description HUD Control
cHSelect = obj_Control.hSelect;
cHCancel = obj_Control.hCancel;
cHRight = obj_Control.right;
cHLeft = obj_Control.left;
cHUp = obj_Control.up;
cHDown = obj_Control.down;
cHToggle = obj_Control.mSelect;

var beamNum = (hasBeam[Beam.Ice]+hasBeam[Beam.Wave]+hasBeam[Beam.Spazer]+hasBeam[Beam.Plasma]),
	itemNum = (item[Item.Missile]+item[Item.SMissile]+item[Item.PBomb]+item[Item.Grapple]+item[Item.XRay]);

if(!global.roomTrans && !obj_PauseMenu.pause)
{
	if(global.HUD == 0)
	{
		itemHighlighted[0] = 0;
		moveHPrev = 1;
		pauseSelect = false;
		
		var itemAmmo = array((item[Item.Missile] && missileStat > 0),(item[Item.SMissile] && superMissileStat > 0),(item[Item.PBomb] && powerBombStat > 0),item[Item.Grapple],item[Item.XRay]);
		var itemNum2 = (itemAmmo[Item.Missile]+itemAmmo[Item.SMissile]+itemAmmo[Item.PBomb]+itemAmmo[Item.Grapple]+itemAmmo[Item.XRay]);
		
		if(itemNum2 > 0)
		{
			if(cHSelect && rHSelect)
			{
				if(itemSelected == 0)
				{
					itemSelected = 1;
				}
				else
				{
					itemHighlighted[1]++;
				}
				
				var numH = 5;
				while(!itemAmmo[scr_wrap(itemHighlighted[1], 0, 4)] && numH > 0)
				{
					itemHighlighted[1]++;
				}
				
				if(itemHighlighted[1] > 4)
				{
					itemSelected = 0;
					itemHighlighted[1] = 0;
				}
				
				audio_play_sound(snd_MenuTick,0,false);
			}
			else if(itemSelected == 1)
			{
				if(!itemAmmo[scr_wrap(itemHighlighted[1], 0, 4)])
				{
					if(itemHighlighted[1] == Item.Missile && itemAmmo[Item.SMissile])
					{
						itemHighlighted[1] = Item.SMissile;
					}
					else if(itemHighlighted[1] == Item.SMissile && itemAmmo[Item.Missile])
					{
						itemHighlighted[1] = Item.Missile;
					}
					else
					{
						itemSelected = 0;
						itemHighlighted[1] = 0;
					}
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			
			if(itemSelected == 1 && ((cHCancel && rHCancel) || itemHighlighted[1] > 4))
			{
				itemSelected = 0;
				itemHighlighted[1] = 0;
				if(cHCancel)
				{
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
		}
		else
		{
			itemSelected = 0;
			itemHighlighted[1] = 0;
		}
		
		if(itemSelected == 0)
		{
			itemHighlighted[1] = 0;
		}
	}
	else if(global.HUD == 1)
	{
		itemHighlighted[0] = 0;
		if(cHCancel && itemNum > 0)
		{
			if(cHCancel && rHCancel)
			{
				audio_play_sound(snd_MenuTick,0,false);
			}
			itemSelected = 1;
		}
		else
		{
			itemSelected = 0;
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
				itemHighlighted[1] += moveH;
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
			itemSelected = scr_wrap(itemSelected + 1, 0, 1);
			audio_play_sound(snd_MenuTick,0,false);
		}
		if(cHSelect)
		{
			global.gamePaused = true;
			/*if(((cHUp && rHUp) || (cHDown && rHDown)) && itemNum > 0)
			{
				itemSelected = scr_wrap(itemSelected + 1, 0, 1);
				audio_play_sound(snd_MenuTick,0,false);
			}*/
			if((itemSelected == 0 && beamNum > 0) || (itemSelected == 1 && itemNum > 1))
			{
				moveH = (cHRight && rHRight) - (cHLeft && rHLeft);
				if(moveH != 0)
				{
					hudBOffsetX = 28*moveH;
					hudIOffsetX = 28*moveH;
					moveHPrev = moveH;
					audio_play_sound(snd_MenuTick,0,false);
				}
				itemHighlighted[itemSelected] += moveH;
			}
			var itemHighlighted2 = scr_wrap(itemHighlighted[0], 1, 4);
			if(itemSelected == 0 && itemHighlighted[0] != 0)
			{
				if(cHToggle && rHToggle && hasBeam[itemHighlighted2])
				{
					beam[itemHighlighted2] = !beam[itemHighlighted2];
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
while(!hasBeam[scr_wrap(itemHighlighted[0], 1, 4)] && itemHighlighted[0] != 0 && numH > 0)
{
	itemHighlighted[0] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
numH = 5;
while(!item[scr_wrap(itemHighlighted[1], 0, 4)] && numH > 0)
{
	itemHighlighted[1] += moveHPrev;
	hudBOffsetX += 28*moveHPrev;
	hudIOffsetX += 28*moveHPrev;
	numH--;
}
for(var i = 0; i < array_length(itemHighlighted); i++)
{
	itemHighlighted[i] = scr_wrap(itemHighlighted[i], 0, 4);
}

rHSelect = !cHSelect;
rHCancel = !cHCancel;
rHRight = !cHRight;
rHLeft = !cHLeft;
rHUp = !cHUp;
rHDown = !cHDown;
rHToggle = !cHToggle;