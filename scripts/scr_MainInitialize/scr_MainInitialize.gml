function scr_MainInitialize()
{
	global.roomTrans = false;	//variable that checks whether the player is transitioning from room to room
	global.gamePaused = false;	//variable that checks if the game is paused

	global.currentPlayFile = 0; //file that is selected and will be saved over during gameplay

	global.rmHeated = false;

	randomize();

	instance_create_depth(0,0,-10,obj_Display);
	instance_create_depth(0,0,0,obj_Audio);
	instance_create_depth(0,0,0,obj_Control);
	instance_create_depth(0,0,0,obj_Progression);
	instance_create_depth(0,0,0,obj_Map);
	instance_create_depth(0,0,0,obj_Particles);
	instance_create_depth(0,0,0,obj_TileFadeHandler);
	instance_create_depth(0,0,0,obj_ScreenShaker);
	
	instance_create_depth(mouse_x,mouse_y,-9,obj_Mouse);
	instance_create_depth(0,0,-8,obj_UIHandler);
	instance_create_depth(0,0,-7,obj_UI_MainMenu);
	instance_create_depth(0,0,-6,obj_PauseMenu);//instance_create_depth(0,0,-6,obj_UI_PauseMenu);
	instance_create_depth(0,0,-5,obj_UI_HUD);

	room_goto(rm_MainMenu); //go to the main menu
	//instance_create_depth(0,0,-7,obj_MainMenu);
	//room_goto(rm_Disclaimer);
	
	lhc_init();

	lhc_create_interface("IPlayer");
	lhc_create_interface("ISolid");
	lhc_create_interface("INPCSolid");
	lhc_create_interface("IMovingSolid");
	lhc_create_interface("ISlope");
	lhc_create_interface("IPlatform");
	lhc_create_interface("IGrapplePoint");
	lhc_create_interface("IBreakable");
	lhc_create_interface("ISpeedBlock");
	lhc_create_interface("IScrewBlock");

	lhc_assign_interface("IPlayer", obj_Player);
	lhc_assign_interface("ISolid", obj_Tile, obj_Gadora);
	lhc_assign_interface("INPCSolid", obj_NPCTile, obj_SaveStation);
	lhc_assign_interface("IMovingSolid", obj_MovingTile);
	lhc_assign_interface("ISlope", obj_Slope, obj_Slope_4th, obj_NPCSlope, obj_NPCSlope_4th, obj_MovingSlope, obj_MovingSlope_4th);
	lhc_assign_interface("IPlatform", obj_Platform);
	lhc_assign_interface("IGrapplePoint", obj_GrappleBlock, obj_GrappleBlockCracked, obj_PushBlock_Grapple, obj_PushBall_Grapple, obj_GrappleRipper);
	lhc_assign_interface("IBreakable", obj_Breakable);
	lhc_assign_interface("ISpeedBlock", obj_ShotBlock, obj_BombBlock, obj_SpeedBlock);
	lhc_assign_interface("IScrewBlock", obj_ShotBlock, obj_BombBlock, obj_ScrewBlock);
	
	chameleon_init();
}
