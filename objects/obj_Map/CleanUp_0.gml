/// @description 

for(var i = array_length(global.mapArea)-1; i >= 0; i--)
{
	surface_free(global.mapArea[i].surf);
}
