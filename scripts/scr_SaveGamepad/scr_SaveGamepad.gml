/// @description scr_SaveGamepad(newbutton,index)
/// @param newbutton
/// @param index
function scr_SaveGamepad(argument0, argument1) {
	var newButton = argument0;

	if(argument1 < array_length_1d(global.gp))
	{
	    for(var i = 0; i < array_length_1d(global.gp); i++)
	    {
	        if(global.gp[i] == newButton)
	        {
	            global.gp[i] = global.gp[argument1];
	        }
	    }
	    global.gp[argument1] = newButton;
	}
	else
	{
	    var mIndex = argument1-array_length_1d(global.gp);

	    for(var i = 0; i < array_length_1d(global.gp_m); i++)
	    {
	        if(global.gp_m[i] == newButton)
	        {
	            global.gp_m[i] = global.gp_m[mIndex];
	        }
	    }
	    global.gp_m[mIndex] = newButton;
	}

	ini_open("settings.ini");
	ini_write_real("Gamepad", "enable dpad", global.gp_usePad);
	ini_write_real("Gamepad", "enable left stick", global.gp_useStick);
	ini_write_real("Gamepad", "dead zone", global.gp_deadZone);

	ini_write_real("Gamepad", "jump", global.gp[0]);
	ini_write_real("Gamepad", "shoot", global.gp[1]);
	ini_write_real("Gamepad", "dash", global.gp[2]);
	ini_write_real("Gamepad", "angle up", global.gp[3]);
	ini_write_real("Gamepad", "angle down", global.gp[4]);
	ini_write_real("Gamepad", "aim lock", global.gp[5]);
	ini_write_real("Gamepad", "quick morph", global.gp[6]);
	ini_write_real("Gamepad", "item select", global.gp[7]);
	ini_write_real("Gamepad", "item cancel", global.gp[8]);

	ini_write_real("Gamepad", "menu start", global.gp_m[0]);
	ini_write_real("Gamepad", "menu select", global.gp_m[1]);
	ini_write_real("Gamepad", "menu cancel", global.gp_m[2]);
	ini_close();



}
