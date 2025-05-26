/// @description scr_GetButtonSprtIndexXB
/// @param button
function scr_GetButtonSprtIndexXB() {

	var button = argument[0];

	switch(button)
	{
		case gp_face1:
		{
			return 0;
		}
		case gp_face2:
		{
			return 1;
		}
		case gp_face3:
		{
			return 2;
		}
		case gp_face4:
		{
			return 3;
		}
	
		case gp_shoulderr:
		{
			return 4;
		}
		case gp_shoulderrb:
		{
			return 5;
		}
		case gp_shoulderl:
		{
			return 6;
		}
		case gp_shoulderlb:
		{
			return 7;
		}
	
		case gp_stickr:
		{
			return 8;
		}
		case gp_stickl:
		{
			return 9;
		}
	
		case gp_start:
		{
			return 10;
		}
		case gp_select:
		{
			return 11;
		}
	}


}
