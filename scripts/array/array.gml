/// @description array(*args);
/// @param *args
function array() {
	var arr;
	for(var i = 0; i < argument_count; i++)
	{
	    arr[i] = argument[i];
	}
	return arr;



}
