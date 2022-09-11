#macro __CHAMELEON_VERSION "v1.0.0"
#macro __CHAMELEON_PREFIX "[Chameleon]"
#macro __CHAMELEON_SOURCE "https://github.com/Lojemiru/Chameleon"
#macro __CHAMELEON_SHADER shChameleon

function __chameleon_log_force(_msg) {
	show_debug_message(__CHAMELEON_PREFIX + " " + _msg);
}

__chameleon_log_force("Loading Chameleon " + __CHAMELEON_VERSION + " by Lojemiru...");
__chameleon_log_force("For assistance, please refer to " + __CHAMELEON_SOURCE);

///@func							chameleon_init();
///@desc							Initializes global data structures for Chameleon. Must be called before Chameleon can be used.
function chameleon_init() {
	// Create global uniform hooks.
	global.__chameleonPalIn = shader_get_sampler_index(__CHAMELEON_SHADER, "in_pal");
	global.__chameleonDataIn = shader_get_uniform(__CHAMELEON_SHADER, "in_palData");
	global.__chameleonMixIn = shader_get_uniform(__CHAMELEON_SHADER, "in_mix");
}

///@func							chameleon_set(sprite, [index = 0]);
///@desc							Starts Chameleon palette swapping. Call only in a draw event! Must be followed with shader_reset().
///@param sprite {sprite}			The palette sprite to use.
///@param index=0 {real}			Optional. The index of the palette sprite to use.
///@param mix=1 {real}				Optional. The amount (between 0 and 1) that the old and new colors should crossfade. 0 is all old, 1 is all new.
function chameleon_set(_palette, _index = 0, _mix = 1) {
	// Set shader.
	shader_set(__CHAMELEON_SHADER);
	
	// Get tex/UV data.
	var tex = sprite_get_texture(_palette, _index),
		uvs = sprite_get_uvs(_palette, _index);
	
	// Pass tex/UV data into shader uniforms.
	shader_set_uniform_f(global.__chameleonDataIn, uvs[0], uvs[1], uvs[2], uvs[3]);
	shader_set_uniform_f(global.__chameleonMixIn, _mix);
	texture_set_stage(global.__chameleonPalIn, tex);
}

///@func							chameleon_set_surface(surface);
///@desc							Starts Chameleon palette swapping using a surface as the reference table. Call only in a draw event! Must be followed with shader_reset().
///@param surface {surface}			The surface to use.
///@param mix=1 {real}				Optional. The amount (between 0 and 1) that the old and new colors should crossfade. 0 is all old, 1 is all new.
function chameleon_set_surface(_palette, _mix = 1) {
	// Set shader.
	shader_set(__CHAMELEON_SHADER);
	
	// Get tex data.
	var tex = surface_get_texture(_palette);
	
	// Pass tex/UV data into shader uniforms.
	// Dummy values, surfaces SHOULD always fully occupy their own texturepage. Or whatever it's considered under the hood.
	shader_set_uniform_f(global.__chameleonDataIn, 0, 0, 1, 1);
	shader_set_uniform_f(global.__chameleonMixIn, _mix);
	texture_set_stage(global.__chameleonPalIn, tex);
}

__chameleon_log_force("Loaded.");