return ((((collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Tile,true,true) || 
		(collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Platform,true,true) && !place_meeting(x,y,obj_Platform)) || 
		(bbox_bottom+1) >= room_height) && velY >= 0 && velY <= fGrav) || (spiderBall && spiderEdge != Edge.None)) && (jump <= 0 || jumpStartFrame > 0));