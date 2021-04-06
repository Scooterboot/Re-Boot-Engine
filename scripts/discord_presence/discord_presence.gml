/// @function     discord_update(details, state, largeImage, smallImage)
/// @description  Updates app's presence
/// @argument     details    
/// @argument     state      
/// @argument     largeImage 
/// @argument     smallImage 
function discord_presence(argument0, argument1, argument2, argument3) {

	external_call(global.__d_update,argument1,argument0,argument2,argument3)


}
