/// @description Delete Surfaces

global.gamePaused = false;

surface_free(SurfaceFront);
surface_free(SurfaceBack);
surface_free(SurfaceFrontTemp);
surface_free(SurfaceBackTemp);
surface_free(AlphaMask);
surface_free(AlphaMaskTemp);
surface_free(BreakMask);
surface_free(BreakMaskTemp);

//surface_free(SurfaceFade);
//surface_free(SurfaceFadeTemp);

for(var i = 0; i < 4; i++)
{
	var lay = layer_get_id("Tiles_fg"+string(i));
	if(layer_exists(lay))
	{
		layer_set_visible(lay,true);
	}
	/*lay = layer_get_id("Tiles_bg"+string(i));
	if(layer_exists(lay))
	{
		layer_set_visible(lay,true);
	}
	lay = layer_get_id("Tiles_fade"+string(i));
	if(layer_exists(lay))
	{
		layer_set_visible(lay,true);
	}*/
}

audio_stop_sound(snd_XRay);
audio_stop_sound(snd_XRay_Loop);

/*with (BackDraw)
{
 instance_destroy();
}*/

/*with (oDoor)
{
 visible = 1;
}*/