/// @function     discord_free()
/// @description  Call when your game ends, frees the dlls and your app

external_free("discord-rpc.dll")
external_free("discord_rich_presence.dll")
external_call(global.__d_free)