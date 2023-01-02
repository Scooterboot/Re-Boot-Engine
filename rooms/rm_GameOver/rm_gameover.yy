{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "rm_GameOver",
  "isDnd": false,
  "volume": 1.0,
  "parentRoom": {
    "name": "rm_Parent",
    "path": "rooms/rm_Parent/rm_Parent.yy",
  },
  "views": [
    {"inherit":false,"visible":true,"xview":96,"yview":0,"wview":256,"hview":224,"xport":0,"yport":0,"wport":256,"hport":224,"hborder":256,"vborder":224,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
    {"inherit":true,"visible":false,"xview":0,"yview":0,"wview":1366,"hview":768,"xport":0,"yport":0,"wport":1366,"hport":768,"hborder":32,"vborder":32,"hspeed":-1,"vspeed":-1,"objectId":null,},
  ],
  "layers": [
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Camera","instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_65040711","properties":[],"isDnd":false,"objectId":{"name":"obj_GameOverMenu","path":"objects/obj_GameOverMenu/obj_GameOverMenu.yy",},"inheritCode":false,"hasCreationCode":false,"colour":4294967295,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"imageIndex":0,"imageSpeed":1.0,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":0.0,"y":0.0,},
      ],"visible":true,"depth":0,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRAssetLayer","resourceVersion":"1.0","name":"HazeAsset","assets":[
        {"resourceType":"GMRSpriteGraphic","resourceVersion":"1.0","name":"graphic_1EFF646E","spriteId":{"name":"sprt_TitleHaze","path":"sprites/sprt_TitleHaze/sprt_TitleHaze.yy",},"headPosition":0.0,"rotation":0.0,"scaleX":1.75,"scaleY":1.0,"animationSpeed":1.0,"colour":4294967295,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":0.0,"y":240.0,},
      ],"visible":true,"depth":100,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"LarvaInstance","instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_115739E3","properties":[],"isDnd":false,"objectId":{"name":"obj_TitleLarva","path":"objects/obj_TitleLarva/obj_TitleLarva.yy",},"inheritCode":false,"hasCreationCode":false,"colour":4294967295,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"imageIndex":0,"imageSpeed":1.0,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":224.0,"y":96.0,},
      ],"visible":true,"depth":200,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRAssetLayer","resourceVersion":"1.0","name":"TubeAsset","assets":[
        {"resourceType":"GMRSpriteGraphic","resourceVersion":"1.0","name":"graphic_58235FDF","spriteId":{"name":"sprt_TitleTube2","path":"sprites/sprt_TitleTube2/sprt_TitleTube2.yy",},"headPosition":0.0,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"animationSpeed":1.0,"colour":4294967295,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":224.0,"y":96.0,},
      ],"visible":true,"depth":300,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Collision","instances":[],"visible":true,"depth":100,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Projectiles_fg","instances":[],"visible":true,"depth":200,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Liquids_fg","instances":[],"visible":true,"depth":300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"TileFadeObjects","instances":[],"visible":true,"depth":400,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade0","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":500,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade1","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":600,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade2","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":700,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade3","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":800,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
      ],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"BTS_Tiles","instances":[],"visible":true,"depth":900,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg0","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1000,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg1","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1100,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg2","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1200,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg3","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
      ],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Liquids","instances":[],"visible":true,"depth":1400,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"WorldObjects","instances":[],"visible":true,"depth":1500,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Player","instances":[],"visible":true,"depth":1600,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Projectiles","instances":[],"visible":true,"depth":1700,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"NPCs","instances":[],"visible":true,"depth":1800,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_bg0","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1900,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_bg1","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":2000,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_bg2","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":2100,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_bg3","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":2200,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
      ],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRBackgroundLayer","resourceVersion":"1.0","name":"Background","spriteId":{"name":"bg_Space","path":"sprites/bg_Space/bg_Space.yy",},"colour":4294967295,"x":11,"y":0,"htiled":true,"vtiled":false,"hspeed":0.0,"vspeed":0.0,"stretch":false,"animationFPS":30.0,"animationSpeedType":0,"userdefinedAnimFPS":false,"visible":true,"depth":2300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
  ],
  "inheritLayers": false,
  "creationCodeFile": "${project_dir}/rooms/rm_GameOver/RoomCreationCode.gml",
  "inheritCode": false,
  "instanceCreationOrder": [
    {"name":"inst_65040711","path":"rooms/rm_GameOver/rm_GameOver.yy",},
    {"name":"inst_115739E3","path":"rooms/rm_GameOver/rm_GameOver.yy",},
  ],
  "inheritCreationOrder": true,
  "sequenceId": null,
  "roomSettings": {
    "inheritRoomSettings": false,
    "Width": 448,
    "Height": 240,
    "persistent": false,
  },
  "viewSettings": {
    "inheritViewSettings": true,
    "enableViews": true,
    "clearViewBackground": false,
    "clearDisplayBuffer": true,
  },
  "physicsSettings": {
    "inheritPhysicsSettings": true,
    "PhysicsWorld": false,
    "PhysicsWorldGravityX": 0.0,
    "PhysicsWorldGravityY": 10.0,
    "PhysicsWorldPixToMetres": 0.1,
  },
  "parent": {
    "name": "Rooms",
    "path": "folders/Rooms.yy",
  },
}