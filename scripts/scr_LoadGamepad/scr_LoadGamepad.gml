function scr_LoadGamepad() {
	ini_open("settings.ini");
	global.gp_usePad = ini_read_real("Gamepad", "enable dpad", true);
	global.gp_useStick = ini_read_real("Gamepad", "enable left stick", true);
	global.gp_deadZone = ini_read_real("Gamepad", "dead zone", 0.5);

	global.gp[0] = ini_read_real("Gamepad", "jump", gp_face1);
	global.gp[1] = ini_read_real("Gamepad", "shoot", gp_face3);
	global.gp[2] = ini_read_real("Gamepad", "dash", gp_face2);
	global.gp[3] = ini_read_real("Gamepad", "angle up", gp_shoulderrb);
	global.gp[4] = ini_read_real("Gamepad", "angle down", gp_shoulderlb);
	global.gp[5] = ini_read_real("Gamepad", "aim lock", gp_shoulderl);
	global.gp[6] = ini_read_real("Gamepad", "quick morph", gp_shoulderr);
	global.gp[7] = ini_read_real("Gamepad", "item select", gp_select);
	global.gp[8] = ini_read_real("Gamepad", "item cancel", gp_face4);

	global.gp_m[0] = ini_read_real("Gamepad", "menu start", gp_start);
	global.gp_m[1] = ini_read_real("Gamepad", "menu select", gp_face1);
	global.gp_m[2] = ini_read_real("Gamepad", "menu cancel", gp_face2);
	ini_close();



}
