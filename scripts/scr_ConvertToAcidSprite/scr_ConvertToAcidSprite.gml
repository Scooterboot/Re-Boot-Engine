function scr_ConvertToAcidSprite(spriteIndex)
{
	switch(spriteIndex)
	{
	    case sprt_WaterBubble:
	    {
	        return sprt_AcidBubble;
	    }
	    case sprt_WaterBubbleSmall:
	    {
	        return sprt_AcidBubbleSmall;
	    }
	    case sprt_WaterBubbleTiny:
	    {
	        return sprt_AcidBubbleTiny;
	    }
	    case sprt_WaterBubbleTiny2:
	    {
	        return sprt_AcidBubbleTiny2;
	    }
	    case sprt_WaterDrop:
	    {
	        return sprt_AcidDrop;
	    }
	    case sprt_WaterBoil:
	    {
	        return sprt_AcidBoil;
	    }
	    case sprt_WaterSkid:
	    {
	        return sprt_AcidSkid;
	    }
	    case sprt_WaterSkidLarge:
	    {
	        return sprt_AcidSkidLarge;
	    }
	    case sprt_WaterSplash:
	    {
	        return sprt_AcidSplash;
	    }
	    case sprt_WaterSplashHuge:
	    {
	        return sprt_AcidSplashHuge;
	    }
	    case sprt_WaterSplashLarge:
	    {
	        return sprt_AcidSplashLarge;
	    }
	    case sprt_WaterSplashSmall:
	    {
	        return sprt_AcidSplashSmall;
	    }
	    case sprt_WaterSplashTiny:
	    {
	        return sprt_AcidSplashTiny;
	    }
		default:
		{
			return spriteIndex;
		}
	}
}