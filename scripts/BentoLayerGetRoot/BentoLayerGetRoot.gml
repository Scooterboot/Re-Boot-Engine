// Feather disable all

/// Returns the root element for the layer.
/// 
/// @param [layerOrName=current]
/// @param environmentOrName

function BentoLayerGetRoot(_layerOrName = undefined, _environmentOrName = undefined)
{
    with(__BentoLayerEnsure(_layerOrName, _environmentOrName))
    {
        if (not BentoExists(__rootElement))
        {
            __rootElement = new BentoConstrAncestor(__BENTO_NO_PARENT);
            __rootElement.BENTO_VARS.__layer = self;
        }
        
        return __rootElement;
    }
    
    return BENTO_NO_ELEMENT;
}