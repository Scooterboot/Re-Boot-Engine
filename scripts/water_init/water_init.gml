/// @description water_init(bottom);

WaterBot = argument0;

InWater = sign(in_water());
InWaterPrev = InWater;
InWaterTop = sign(in_water_top());
InWaterTopPrev = InWaterTop;

SplashY = y;

WaterLerp = 0;

EnteredWater = -1;
LeftWaterTop = -1;
LeftWater = -1;

WaterShuffleCount = 0;
WaterShuffleSoundID[0] = snd_WaterShuffle1;
WaterShuffleSoundID[1] = snd_WaterShuffle2;
WaterShuffleSoundID[2] = snd_WaterShuffle3;
WaterShuffleSoundID[3] = snd_WaterShuffle4;