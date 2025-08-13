/// @description Delete Surfaces

global.gamePaused = false;

surface_free(surfaceFront);
surface_free(surfaceBack);
surface_free(surfaceFrontTemp);
surface_free(surfaceBackTemp);
surface_free(alphaMask);
surface_free(alphaMaskTemp);
surface_free(breakMask);
surface_free(breakMaskTemp);

surface_free(outlineSurf);
surface_free(outlineSurf2);
surface_free(outlineSurfTemp);

for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],true);
}
for(var i = 0; i < array_length(bgTileLayers); i++)
{
	layer_set_visible(bgTileLayers[i],true);
}

audio_stop_sound(snd_XRay);
audio_stop_sound(snd_XRay_Loop);

instance_destroy(backDraw);