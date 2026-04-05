// Feather disable all



// Icon data to return when a binding is empty
InputIconDefineEmpty(undefined); //"empty");

// Icon data to return when a binding is unsupported on the target device
InputIconDefineUnsupported("[[!]"); //"unsupported");



////////////////////////////
//                        //
//  Unknown Gamepad Type  //
//                        //
////////////////////////////

// Icon data to return when a gamepad type is unrecognised or unsupported

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face1, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,0)); //"face south");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face2, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,1)); //"face east" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face3, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,2)); //"face west" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face4, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,3)); //"face north");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderl,  new UISpriteIcon(sprt_UI_GPIcon_Shoulders,0)); //"shoulder l");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderr,  new UISpriteIcon(sprt_UI_GPIcon_Shoulders,1)); //"shoulder r");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderlb, new UISpriteIcon(sprt_UI_GPIcon_Shoulders,2)); //"trigger l" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderrb, new UISpriteIcon(sprt_UI_GPIcon_Shoulders,3)); //"trigger r" );

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_select, sprt_UI_GPIcon_Select); //"select");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_start,  sprt_UI_GPIcon_Start); //"start" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_home,   sprt_UI_GPIcon_Home); //"home"  );

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padl, sprt_UI_GPIcon_DPad_Left); //"dpad left" ); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padr, sprt_UI_GPIcon_DPad_Right); //"dpad right"); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padu, sprt_UI_GPIcon_DPad_Up); //"dpad up"   ); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padd, sprt_UI_GPIcon_DPad_Down); //"dpad down" ); 

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axislh, sprt_UI_GPIcon_LStick_Left); //"thumbstick l left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axislh, sprt_UI_GPIcon_LStick_Right); //"thumbstick l right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axislv, sprt_UI_GPIcon_LStick_Up); //"thumbstick l up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axislv, sprt_UI_GPIcon_LStick_Down); //"thumbstick l down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_stickl, sprt_UI_GPIcon_LStick_Click); //"thumbstick l click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axisrh, sprt_UI_GPIcon_RStick_Left); //"thumbstick r left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axisrh, sprt_UI_GPIcon_RStick_Right); //"thumbstick r right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axisrv, sprt_UI_GPIcon_RStick_Up); //"thumbstick r up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axisrv, sprt_UI_GPIcon_RStick_Down); //"thumbstick r down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_stickr, sprt_UI_GPIcon_RStick_Click); //"thumbstick r click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddler,  new UISpriteIcon(sprt_UI_GPIcon_Paddles,0)); //"paddle r" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlel,  new UISpriteIcon(sprt_UI_GPIcon_Paddles,1)); //"paddle l" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlerb, new UISpriteIcon(sprt_UI_GPIcon_Paddles,2)); //"paddle rb");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlelb, new UISpriteIcon(sprt_UI_GPIcon_Paddles,3)); //"paddle lb");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra1, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,4)); //"extra 1");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra2, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,5)); //"extra 2");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra3, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,6)); //"extra 3");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra4, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,7)); //"extra 4");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra5, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons1,8)); //"extra 5");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra6, new UISpriteIcon(sprt_UI_GPIcon_FaceButtons2,0)); //"extra 6");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_touchpadbutton, sprt_UI_GPIcon_TouchPad); //"touchpad");