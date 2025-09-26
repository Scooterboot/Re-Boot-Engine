function scr_MainInitialize()
{
	//global.roomTrans = false;	//variable that checks whether the player is transitioning from room to room
	//global.gamePaused = false;	//variable that checks if the game is paused
	enum PauseState
	{
		None,
		PauseMenu,
		MessageBox,
		RoomTrans,
		DeathAnim,
		ItemMenu,
		XRay
	}
	global.pauseState = PauseState.None;
	global.GamePaused = function() { return global.pauseState != PauseState.None; }

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
	
	#macro ColType_Player [obj_Player]
	#macro ColType_Solid [obj_Tile, obj_Gadora]
	#macro ColType_SolidSlope [obj_Slope, obj_Slope_4th]
	#macro ColType_NPCSolid [obj_NPCTile, obj_SaveStation]
	#macro ColType_NPCSolidSlope [obj_NPCSlope, obj_NPCSlope_4th]
	#macro ColType_MovingSolid [obj_MovingTile]
	#macro ColType_MovingSolidSlope [obj_MovingSlope, obj_MovingSlope_4th]
	#macro ColType_Platform [obj_Platform]
	#macro ColType_GrapplePoint [obj_GrappleBlock, obj_GrappleBlockCracked, obj_MagnetGrappleBlock, obj_PushBlock_Grapple, obj_PushBall_Grapple, obj_GrappleRipper]
	#macro ColType_MagnetTrack [obj_MagnetTrackBlock]
	#macro ColType_Breakable [obj_Breakable]
	#macro ColType_BoostBallBlock [obj_ShotBlock, obj_BoostBallBlock]
	#macro ColType_SpeedBlock [obj_ShotBlock, obj_BombBlock, obj_BoostBallBlock, obj_SpeedBlock]
	#macro ColType_ScrewBlock [obj_ShotBlock, obj_BombBlock, obj_ScrewBlock]
	
	chameleon_init();
}
