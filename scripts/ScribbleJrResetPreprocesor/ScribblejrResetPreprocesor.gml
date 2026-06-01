// Feather disable all

/// Resets the current preprocessor to the default, as set by `ScribbleJrSetPreprocesorDefault()`.

function ScribbleJrResetPreprocesor()
{
    static _system = __ScribbleJrSystem();
    
    with(_system)
    {
        if (not __preprocessorUsingDefault)
        {
            __preprocessorUsingDefault = true;
            
            __preprocessorMethod = __preprocessorDefault;
            __preprocessorName   = __preprocessorDefaultName;
            
            __preprocessorOnce = false;
        }
    }
}