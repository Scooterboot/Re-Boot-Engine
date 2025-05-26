/// @decription scr_DeleteGame
/// @param savefile
function scr_DeleteGame() {

	var file = argument[0];

	if(file_exists(scr_GetFileName(file)))
	{
		file_delete(scr_GetFileName(file));
	}


}
