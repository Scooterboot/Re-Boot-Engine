function scr_ConvertToLavaSprite(spriteIndex)
{
	switch(spriteIndex)
	{
	    case sprt_WaterBubble:
	    {
	        return sprt_LavaBubble;
	    }
	    case sprt_WaterBubbleSmall:
	    {
	        return sprt_LavaBubbleSmall;
	    }
	    case sprt_WaterBubbleTiny:
	    {
	        return sprt_LavaBubbleTiny;
	    }
	    case sprt_WaterBubbleTiny2:
	    {
	        return sprt_LavaBubbleTiny2;
	    }
	    case sprt_WaterDrop:
	    {
	        return sprt_LavaDrop;
	    }
	    case sprt_WaterSkid:
	    {
	        return sprt_LavaSkid;
	    }
	    case sprt_WaterSkidLarge:
	    {
	        return sprt_LavaSkidLarge;
	    }
	    case sprt_WaterSplash:
	    {
	        return sprt_LavaSplash;
	    }
	    case sprt_WaterSplashHuge:
	    {
	        return sprt_LavaSplashHuge;
	    }
	    case sprt_WaterSplashLarge:
	    {
	        return sprt_LavaSplashLarge;
	    }
	    case sprt_WaterSplashSmall:
	    {
	        return sprt_LavaSplashSmall;
	    }
	    case sprt_WaterSplashTiny:
	    {
	        return sprt_LavaSplashTiny;
	    }
		default:
		{
			return spriteIndex;
		}
	}
}