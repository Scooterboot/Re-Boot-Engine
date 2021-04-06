function scr_LoadKeyboard() {
	ini_open("settings.ini");
	global.key[0] = ini_read_real("Keyboard", "up", vk_up);
	global.key[1] = ini_read_real("Keyboard", "down", vk_down);
	global.key[2] = ini_read_real("Keyboard", "left", vk_left);
	global.key[3] = ini_read_real("Keyboard", "right", vk_right);
	global.key[4] = ini_read_real("Keyboard", "jump", ord("Z"));
	global.key[5] = ini_read_real("Keyboard", "shoot", ord("X"));
	global.key[6] = ini_read_real("Keyboard", "dash", ord("C"));
	global.key[7] = ini_read_real("Keyboard", "angle up", ord("S"));
	global.key[8] = ini_read_real("Keyboard", "angle down", ord("A"));
	global.key[9] = ini_read_real("Keyboard", "aim lock", ord("D"));
	global.key[10] = ini_read_real("Keyboard", "quick morph", ord("V"));
	global.key[11] = ini_read_real("Keyboard", "item select", ord("Q"));
	global.key[12] = ini_read_real("Keyboard", "item cancel", ord("W"));

	global.key_m[0] = ini_read_real("Keyboard", "menu start", vk_enter);
	global.key_m[1] = ini_read_real("Keyboard", "menu select", ord("Z"));
	global.key_m[2] = ini_read_real("Keyboard", "menu cancel", ord("X"));
	ini_close();



}
