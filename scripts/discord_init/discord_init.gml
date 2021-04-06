/// @function     discord_init(appID)
/// @description  Initializes the DLLs/Application ID
/// @argument     appID 
function discord_init(argument0) {

	dll = "discord_rich_presence.dll";

	global.__d_init = external_define(dll,"InitDiscord",dll_cdecl,ty_real,1,ty_string)
	global.__d_update = external_define(dll,"UpdatePresence",dll_cdecl,ty_real,4,ty_string,ty_string,ty_string,ty_string)
	global.__d_free = external_define(dll,"FreeDiscord",dll_cdecl,ty_real,0)

	return external_call(global.__d_init,argument0);


}
