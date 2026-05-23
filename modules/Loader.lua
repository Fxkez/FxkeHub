return function(ctx, script)
    getgenv().FxkeCtx = ctx
    getgenv().FxkeWindow = ctx.Window
    getgenv().FxkeNebulaIcons = ctx.NebulaIcons
    getgenv().FxkeStarlight = ctx.Starlight
    getgenv().FxkeNotify = ctx.notify or function() end

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fxkez/FxkeHub/main/modules/"..script))()
end
