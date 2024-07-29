///scr_DrawHUD_Energy
function scr_DrawHUD_Energy() {

	var vX = camera_get_view_x(view_camera[0]),
		vY = camera_get_view_y(view_camera[0]);

	var col = c_black, alpha = 0.4;

	var xx = vX+2,
		yy = vY+2,
		ww = 49,
		hh = 8,
		yDiff = 0;

	var energyTanks = floor(energyMax / 100);

	if(energyTanks > 0)
	{
		yDiff = 7;
		if(energyTanks > 1)//7)
		{
			yDiff = 14;
		}
	}

	draw_set_color(col);
	draw_set_alpha(alpha);

	var x2 = xx-1,
		y2 = yy-1;

	//draw_rectangle(x2,y2,x2+ww,y2+hh+yDiff,false);
	if(energyTanks <= 14)
	{
		var ww2 = 0;
		if(energyTanks > 0)
		{
			ww2 = 7 * scr_ceil(energyTanks/2);
			draw_rectangle(x2,y2,x2+ww2,y2+hh+yDiff,false);
		
			ww2 += 1;
		}
		draw_rectangle(x2+ww2,y2+yDiff,x2+ww,y2+hh+yDiff,false);
	}
	else
	{
		if(energyTanks > 0)
		{
			var ww2 = 7 * scr_ceil(energyTanks/2);
			draw_rectangle(x2,y2,x2+ww2,y2+yDiff,false);
		}
		draw_rectangle(x2,y2+yDiff+1,x2+ww,y2+hh+yDiff,false);
	}

	draw_set_color(c_white);
	draw_set_alpha(1);

	statEnergyTanks = floor(energy / 100);

	draw_sprite_ext(sprt_UI_HEnergyText,0,floor(xx),floor(yy+yDiff),1,1,0,c_white,1);

	draw_sprite_ext(sprt_UI_HNumFont1,energy,floor(xx+41),floor(yy+yDiff),1,1,0,c_white,1);
	var energyNum = floor(energy/10);
	draw_sprite_ext(sprt_UI_HNumFont1,energyNum,floor(xx+35),floor(yy+yDiff),1,1,0,c_white,1);

	if(energyTanks > 0)
	{
		/*for(var i = 0; i < energyTanks; i++)
		{
			var eX = xx + (7*i),
			eY = yy;
			if(energyTanks > 7)
			{
				eY = yy+7;
			}
			if(i >= 7)
			{
				eX = xx + (7*(i-7));
				eY = yy;
			}
			draw_sprite_ext(sprt_HETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
		}*/
		for(var i = 0; i < energyTanks; i++)
		{
			var eX = xx + (7*i)/2,
				eY = yy;
			if(i%2 != 0)
			{
				eX = xx + (7*(i-1))/2;
				eY = yy+7;
			}
			draw_sprite_ext(sprt_UI_HETank,(statEnergyTanks > i),floor(eX),floor(eY),1,1,0,c_white,1);
		}
	}
	
	if(global.HUD == 2)
	{
		yDiff = max(yDiff,10);
	}
	else if(item[Item.Missile])
	{
		yDiff = max(yDiff,7);
	}
	if(boots[Boots.Dodge])
	{
		var _meterY = yy+yDiff+8;
		if(boots[Boots.SpeedBoost])
		{
			_meterY += 5;
		}
		for(var i = 0; i < 2; i += 1)
		{
			draw_sprite_ext(sprt_UI_DodgeMeter,0,xx+14*i,_meterY,1,1,0,c_white,1);
		
			var recharge = clamp((dodgeRecharge / (dodgeRechargeMax/2)) - i,0,1);
			var width = sprite_get_width(sprt_UI_DodgeMeter)*recharge;
			var height = sprite_get_height(sprt_UI_DodgeMeter);
			var imgInd = 1 + (canDodge && recharge >= 1);
			for(var j = 0; j < height; j++)
			{
				var rw = min(width-j+1,width);
				if(rw > 0)
				{
					draw_sprite_part_ext(sprt_UI_DodgeMeter,imgInd,0,j,rw,1,xx+14*i,_meterY+j,1,1,c_white,1);
				}
			}
		}
	}
	
	if(boots[Boots.SpeedBoost])
	{
		var _meterY = yy+yDiff+8;
		var width = sprite_get_width(sprt_UI_SpeedMeter);
		var height = sprite_get_height(sprt_UI_SpeedMeter);
		
		draw_sprite_ext(sprt_UI_SpeedMeter,0,xx,_meterY,1,1,0,c_white,1);
		
		if(shineCharge > 0)
		{
			width *= shineCharge / shineChargeMax;
			for(var j = 0; j < height; j++)
			{
				var rw = min(width-j+1,width);
				if(rw > 0)
				{
					draw_sprite_part_ext(sprt_UI_SpeedMeter,1,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
				}
			}
		}
		
		var _widths = [12,15,19,23];
		var _prevWidth = 0;
		for(var i = 0; i < speedCounter; i++)
		{
			_prevWidth += _widths[i];
		}
		
		if(speedCounter < 4)
		{
			width = _prevWidth + _widths[speedCounter] * ((speedBuffer+1) / speedBufferMax);
			for(var j = 0; j < height; j++)
			{
				var rw = min(width-j+1,width);
				if(rw > 0)
				{
					draw_sprite_part_ext(sprt_UI_SpeedMeter,2,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
				}
			}
		}
		
		if(!walkState)
		{
			width = sprite_get_width(sprt_UI_SpeedMeter);
			if(SpiderActive())
			{
				width *= power((abs(spiderSpeed) / minBoostSpeed),2);
			}
			else
			{
				width *= power((abs(velX) / minBoostSpeed),2);
			}
			for(var j = 0; j < height; j++)
			{
				var rw = min(width-j+1,width);
				if(rw > 0)
				{
					draw_sprite_part_ext(sprt_UI_SpeedMeter,3,0,j,rw,1,xx,_meterY+j,1,1,c_white,1);
				}
			}
		}
		
		if(speedCounter >= 4 || state == State.Spark || state == State.BallSpark)
		{
			draw_sprite_ext(sprt_UI_SpeedMeter,4,xx,_meterY,1,1,0,c_white,1);
		}
	}
}
