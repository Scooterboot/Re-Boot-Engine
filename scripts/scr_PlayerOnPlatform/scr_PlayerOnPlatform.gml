return (place_meeting(x,y+1,obj_Platform) && !place_meeting(x,y,obj_Platform) && 
		fVelY >= 0 && state != "spark" && state != "ballSpark");