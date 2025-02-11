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
	
	global.colArr_Player = [obj_Player];
	global.colArr_Solid = [obj_Tile, obj_Gadora];
	global.colArr_SolidSlope = [obj_Slope, obj_Slope_4th];
	global.colArr_NPCSolid = [obj_NPCTile, obj_SaveStation];
	global.colArr_NPCSolidSlope = [obj_NPCSlope, obj_NPCSlope_4th];
	global.colArr_MovingSolid = [obj_MovingTile];
	global.colArr_MovingSolidSlope = [obj_MovingSlope, obj_MovingSlope_4th];
	global.colArr_Platform = [obj_Platform];
	global.colArr_GrapplePoint = [obj_GrappleBlock, obj_GrappleBlockCracked, obj_PushBlock_Grapple, obj_PushBall_Grapple, obj_GrappleRipper];
	global.colArr_Breakable = [obj_Breakable];
	global.colArr_SpeedBlock = [obj_ShotBlock, obj_BombBlock, obj_SpeedBlock];
	global.colArr_ScrewBlock = [obj_ShotBlock, obj_BombBlock, obj_ScrewBlock];
	
	chameleon_init();
}
