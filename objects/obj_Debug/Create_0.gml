
debug = 0;

zoomTempFlag = false;
fastforwardtoggle = false;
defaultGameSpeed = game_get_speed(gamespeed_fps);

entityOutlineSurf = surface_create(1,1);
entityOutlineSurf2 = surface_create(1,1);

stateText[State.Stand] =		"Stand";
stateText[State.Elevator] =		"Elevator";
stateText[State.Recharge] =		"Recharge";
stateText[State.Slide] =		"Slide";
stateText[State.Crouch] =		"Crouch";
stateText[State.Morph] =		"Morph";
stateText[State.CrystalFlash] =	"CrystalFlash";
stateText[State.Jump] =			"Jump";
stateText[State.Somersault] =	"Somersault";
stateText[State.Grip] =			"Grip";
stateText[State.Dodge] =		"Dodge";
stateText[State.Spark] =		"Spark";
stateText[State.BallSpark] =	"BallSpark";
stateText[State.Grapple] =		"Grapple";
stateText[State.GravGrapple] =	"GravGrapple";
stateText[State.Hurt] =			"Hurt";
stateText[State.DmgBoost] =		"DmgBoost";
stateText[State.Death] =		"Death";

moveStateText[MoveState.Default] =		"Default";
moveStateText[MoveState.Somersault] =	"Somersault";
moveStateText[MoveState.Slide] =		"Slide";
moveStateText[MoveState.Crouch] =		"Crouch";
moveStateText[MoveState.MoonPrep] =		"MoonPrep";
moveStateText[MoveState.Custom] =		"Custom";

animStateText[AnimState.Stand] =		"Stand";
animStateText[AnimState.Run] =			"Run";
animStateText[AnimState.Brake] =		"Brake";
animStateText[AnimState.Walk] =			"Walk";
animStateText[AnimState.MoonPrep] =		"MoonPrep";
animStateText[AnimState.Push] =			"Push";
animStateText[AnimState.Slide] =		"Slide";
animStateText[AnimState.Crouch] =		"Crouch";
animStateText[AnimState.Morph] =		"Morph";
animStateText[AnimState.CrystalFlash] =	"CrystalFlash";
animStateText[AnimState.Jump] =			"Jump";
animStateText[AnimState.Somersault] =	"Somersault";
animStateText[AnimState.Grip] =			"Grip";
animStateText[AnimState.Dodge] =		"Dodge";
animStateText[AnimState.Spark] =		"Spark";
animStateText[AnimState.Grapple] =		"Grapple";
animStateText[AnimState.GravGrapple] =	"GravGrapple";
animStateText[AnimState.Hurt] =			"Hurt";
animStateText[AnimState.DmgBoost] =		"DmgBoost";

edgeText[Edge.None] =	"None";
edgeText[Edge.Bottom] = "Bottom";
edgeText[Edge.Top] =	"Top";
edgeText[Edge.Right] =	"Right";
edgeText[Edge.Left] =	"Left";