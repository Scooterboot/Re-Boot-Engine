function gp_anybutton(slotOverride = -1)
{
	var slot = global.gpSlot;
	if(slotOverride > -1)
	{
		slot = slotOverride;
	}
	var gp_index = 0;
	for(gp_index = gp_face1; gp_index < gp_face1+global.gpButtonNum; gp_index++)
	{
		if(gamepad_button_check(slot, gp_index))
		{
			break;
		}
	}
	return gp_index;
}
