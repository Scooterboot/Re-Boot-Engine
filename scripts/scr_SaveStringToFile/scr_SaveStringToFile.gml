/// @desc scr_SaveStringToFile
/// @arg filename
/// @arg string
function scr_SaveStringToFile() {

	var _filename = argument[0],
		_string = argument[1];

	var _buffer = buffer_create(string_byte_length(_string)+1, buffer_fixed, 1);
	buffer_write(_buffer,buffer_string,_string);
	buffer_save(_buffer,_filename);
	buffer_delete(_buffer);


}
