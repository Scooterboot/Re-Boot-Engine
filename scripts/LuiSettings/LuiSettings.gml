//Info
#macro LIMEUI_VERSION "2025.02.07"

//Globals
global.lui_debug_mode =	0;						// Enable/Disable debug mode
global.lui_debug_render_grid = false;			// Enable/Disable render of debug grid

//System (do not change!)
#macro LUI_AUTO							-1		// Auto position/size of an element
#macro LUI_AUTO_NO_PADDING				-2		// (WIP)//???//
#macro LUI_STRETCH						-3		// (WIP)//???//

//Settings
#macro LUI_GRID_SIZE					32//128		// UI grid size for elements
#macro LUI_GRID_ACCURACY				32//128		// Same as grid size is good, but you can use low size for pixel styles ui maybe...
#macro LUI_LOG_ERROR_MODE				1		// 0 - do not log, 1 - errors only, 2 - errors and warnings
#macro LUI_DEBUG_CALLBACK				false	// Turn on/off debug default callback for all elements
#macro LUI_FORCE_ALPHA_1				true