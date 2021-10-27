/// @description Respawn Tile

if(place_meeting(x,y,obj_Player))
{
    for(var i = 0; i < image_xscale; i++)
    {
        for(var j = 0; j < image_yscale; j++)
        {
            part_particles_create(obj_Particles.partSystemD,x+16*i,y+16*j,obj_Particles.blockBreak[breakType],1);
        }
    }
    var re = instance_create_layer(x,y,layer,obj_BlockRespawn);
    re.sprite_index = sprite_index;
    re.breakType = breakType;
    re.blockIndex = blockIndex;//object_index;
    re.respawnTime = initialTime;
    re.initialTime = initialTime;
    re.image_xscale = image_xscale;
    re.image_yscale = image_yscale;
    re.right = right;
    re.left = left;
    re.up = up;
    re.down = down;
    re.upright = upright;
    re.upleft = upleft;
    re.downright = downright;
    re.downleft = downleft;
}
else if(blockIndex != noone)
{
    var bl = instance_create_layer(x,y,layer,blockIndex);
    bl.visible = true;
    bl.respawnTime = initialTime;
    bl.image_xscale = image_xscale;
    bl.image_yscale = image_yscale;
    bl.right = right;
    bl.left = left;
    bl.up = up;
    bl.down = down;
    bl.upright = upright;
    bl.upleft = upleft;
    bl.downright = downright;
    bl.downleft = downleft;
}