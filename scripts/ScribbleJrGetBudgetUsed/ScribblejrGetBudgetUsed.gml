// Feather disable all

/// Returns how much time Scribble Jr. used to bake vertex buffers in the previous Step, measured
/// in microseconds. This value will sometimes be a little more than the time budget set by
/// ScribbleJrGetBudget().

function ScribbleJrGetBudgetUsed()
{
    static _system = __ScribbleJrSystem();
    return _system.__budgetUsedPrev;
}