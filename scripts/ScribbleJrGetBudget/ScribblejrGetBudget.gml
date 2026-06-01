// Feather disable all

/// Returns the Scribble Jr. baking time budget, measured in microseconds.

function ScribbleJrGetBudget()
{
    static _system = __ScribbleJrSystem();
    return _system.__budget;
}