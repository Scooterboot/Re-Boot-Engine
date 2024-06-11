/// @description Free surface
event_inherited();

surface_free(lavaSurface);
surface_free(finalSurface);

audio_stop_sound(ambSnd[0]);
audio_stop_sound(ambSnd[1]);
audio_stop_sound(ambSnd[2]);