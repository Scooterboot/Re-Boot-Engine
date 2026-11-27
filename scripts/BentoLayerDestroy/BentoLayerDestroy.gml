// Feather disable all

/// Destroys a layer.
/// 
/// @param [layerOrName=current]
/// @param environmentOrName

function BentoLayerDestroy(_layerOrName = undefined, _environmentOrName = undefined)
{
    var _layer = __BentoLayerSeek(_layerOrName, _environmentOrName);
    if (_layer != undefined) _layer.__Destroy();
}