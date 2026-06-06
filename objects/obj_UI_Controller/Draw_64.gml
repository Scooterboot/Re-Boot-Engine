
if(room == rm_MainMenu || room == rm_GameOver || room == rm_Disclaimer || global.GamePaused())
{
	surface_set_target(obj_Display.surfUI);
	bm_set_one();

	BentoSystemDraw();

	bm_reset();
	surface_reset_target();
}
