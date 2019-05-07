/// @description pal_swap_set_tiles(palette sprite or surface, pal index, start layer, end layer, pal is surface);
/// @param palette sprite or surface
/// @param  pal index
/// @param  start layer
/// @param  end layer
/// @param  pal is surface
//Call this every step you want to draw the tiles palette swapped.  Stop calling it, or set the pal index to 0 to stop palette swapping.
//Does not need to be called in a draw event.  In fact, I recommend the step event.
var _pal_sprite = argument[0];
var _pal_index = argument[1];

var _low =argument[2]+1;
var _high = argument[3]-1;
var _is_surface = argument[4];

if(_low<_high)
{   //You passed the arguments in backwards, nimrod.
    _low=argument[3]-1;
    _high=argument[2]+1;
    //Sorry.  It's not really a big deal.  If it makes you feel better, Nimrod was actually a mighty warrior.
    //Look it up.
}    

///Check the start object-------------------------
var _start_exists=false;
with(obj_tile_swapper_start)
{
    if(depth==_low)
    {   //Object already exists, update the values.
        _start_exists=true;
        active=true;
        pal_sprite=_pal_sprite;
        pal_index=_pal_index;
        pal_is_surface=_is_surface;
    }
}

if(!_start_exists)
{   //Object does not exist.  Create it.
    with(instance_create_depth(0,0,0,obj_tile_swapper_start))
    {
        active=true;
        depth=_low;
        pal_sprite=_pal_sprite;
        pal_index=_pal_index;
        pal_is_surface=_is_surface;
    }
}

///Check the start object-------------------------
var _end_exists=false;
with(obj_tile_swapper_end)
{
    if(depth==_high)
    {   //Object already exists, update the values.
        _end_exists=true;
        active=true;
    }
}

if(!_end_exists)
{   //Object does not exist.  Create it.
    with(instance_create_depth(0,0,0,obj_tile_swapper_end))
    {
        active=true;
        depth=_high;
    }
}

