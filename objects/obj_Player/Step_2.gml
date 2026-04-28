/// @description Deal damage

if(global.pauseState == PauseState.None)
{
	#region Charge Somersault / Pseudo Screw Attack Dmg box
	
	if(self.IsChargeSomersaulting() && !self.IsSpeedBoosting() && !self.IsScrewAttacking())
	{
		var psDmg = currentWeapon.chargeDamage * currentWeapon.chargeShotAmount * 2;
		var dmgST = array_create(DmgSubType_Beam._Length,false);
		dmgST[DmgSubType_Beam.All] = true;
		dmgST[DmgSubType_Beam.Power] = true;
		dmgST[DmgSubType_Beam.Ice] = item[Item.IceBeam];
		dmgST[DmgSubType_Beam.Wave] = item[Item.WaveBeam];
		dmgST[DmgSubType_Beam.Spazer] = item[Item.Spazer];
		dmgST[DmgSubType_Beam.Plasma] = item[Item.PlasmaBeam];
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
		{
			dmgBoxes[PlayerDmgBox.PseudoScrew] = self.CreateDamageBox(0,0,screwAttackMask,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
		{
			dmgBoxes[PlayerDmgBox.PseudoScrew].Damage(x, y, psDmg, DmgType.Charge, dmgST, , , 3);
		}
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.PseudoScrew]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.PseudoScrew]);
	}
	
	#endregion
	#region Boost Ball Dmg box
	
	if(boostBallDmgCounter > 0)
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.BoostBall] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
		{
			dmgBoxes[PlayerDmgBox.BoostBall] = self.CreateDamageBox(0,0,mask_index,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
		{
			dmgBoxes[PlayerDmgBox.BoostBall].mask_index = mask_index;
			dmgBoxes[PlayerDmgBox.BoostBall].Damage(x, y, 300*boostBallDmgCounter, DmgType.Misc, dmgST, , , 3);
		}
		
		boostBallDmgCounter = max(boostBallDmgCounter - 0.0375, 0);
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.BoostBall]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.BoostBall]);
	}
	
	#endregion
	#region Speed Boost / Shine Spark Dmg box(es)
	
	if(self.IsSpeedBoosting())
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.SpeedBoost] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			dmgBoxes[PlayerDmgBox.SpeedBoost] = self.CreateDamageBox(0,0,mask_index,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			dmgBoxes[PlayerDmgBox.SpeedBoost].mask_index = mask_index;
			dmgBoxes[PlayerDmgBox.SpeedBoost].Damage(x, y, 2000, DmgType.Misc, dmgST, , , 3);
		}
		
		if(state == State.Spark && shineStart <= 0 && shineEnd <= 0)
		{
			if(!instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
			{
				dmgBoxes[PlayerDmgBox.ShineSpark] = self.CreateDamageBox(0,0,shineSparkMask,false);
			}
			if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
			{
				var shineRot = shineDir - 90;
				var len = 6;
				var shineX = scr_round(x + lengthdir_x(len,shineRot)),
					shineY = scr_round(y + lengthdir_y(len,shineRot));
				
				var ssbox = dmgBoxes[PlayerDmgBox.ShineSpark];
				ssbox.direction = shineRot;
				ssbox.image_angle = shineRot;
				ssbox.Damage(shineX, shineY, 2000, DmgType.Misc, dmgST, , , 3);
			}
		}
		else if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.ShineSpark]);
		}
	}
	else
	{
		if(instance_exists(dmgBoxes[PlayerDmgBox.SpeedBoost]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.SpeedBoost]);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.ShineSpark]))
		{
			instance_destroy(dmgBoxes[PlayerDmgBox.ShineSpark]);
		}
	}
	
	#endregion
	#region Screw Attack Dmg box
	
	if(self.IsScrewAttacking())
	{
		var dmgST = array_create(DmgSubType_Misc._Length,false);
		dmgST[DmgSubType_Misc.All] = true;
		dmgST[DmgSubType_Misc.ScrewAttack] = true;
		
		if(!instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
		{
			dmgBoxes[PlayerDmgBox.ScrewAttack] = self.CreateDamageBox(0,0,screwAttackMask,false);
		}
		if(instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
		{
			dmgBoxes[PlayerDmgBox.ScrewAttack].Damage(x, y, 2000, DmgType.Misc, dmgST, , , 3);
		}
	}
	else if(instance_exists(dmgBoxes[PlayerDmgBox.ScrewAttack]))
	{
		instance_destroy(dmgBoxes[PlayerDmgBox.ScrewAttack]);
	}
	
	#endregion
	
	self.IncrInvFrames();
}
