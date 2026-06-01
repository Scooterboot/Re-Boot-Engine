// Feather disable all

/// Returns whether per-character wrapping is enabled or not.

function ScribbleJrGetCharacterWrap()
{
    static _system = __ScribbleJrSystem();
    return _system.__perCharacterWrap;
}