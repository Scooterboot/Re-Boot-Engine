/// @description Chain Destroy
event_inherited();

if(right)
{
    with(instance_place(x+16,y,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(left)
{
    with(instance_place(x-16,y,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(up)
{
    with(instance_place(x,y-16,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(down)
{
    with(instance_place(x,y+16,obj_ChainBlock))
    {
        destroy = true;
    }
}

if(upright)
{
    with(instance_place(x+16,y-16,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(upleft)
{
    with(instance_place(x-16,y-16,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(downright)
{
    with(instance_place(x+16,y+16,obj_ChainBlock))
    {
        destroy = true;
    }
}
if(downleft)
{
    with(instance_place(x-16,y+16,obj_ChainBlock))
    {
        destroy = true;
    }
}