{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "rm_MainMenu",
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
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Camera","instances":[],"visible":true,"depth":0,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Collision","instances":[],"visible":true,"depth":100,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRAssetLayer","resourceVersion":"1.0","name":"HazeAsset","assets":[
        {"resourceType":"GMRSpriteGraphic","resourceVersion":"1.0","name":"graphic_38172719","spriteId":{"name":"sprt_TitleHaze","path":"sprites/sprt_TitleHaze/sprt_TitleHaze.yy",},"headPosition":0.0,"rotation":0.0,"scaleX":1.7500001,"scaleY":1.0,"animationSpeed":1.0,"colour":4294967295,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":0.0,"y":240.0,},
      ],"visible":true,"depth":200,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"LarvaInstance","instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_12E9934F","properties":[],"isDnd":false,"objectId":{"name":"obj_TitleLarva","path":"objects/obj_TitleLarva/obj_TitleLarva.yy",},"inheritCode":false,"hasCreationCode":false,"colour":4294967295,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"imageIndex":0,"imageSpeed":1.0,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":224.0,"y":144.0,},
      ],"visible":true,"depth":300,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRAssetLayer","resourceVersion":"1.0","name":"TerminalAssets","assets":[
        {"resourceType":"GMRSpriteGraphic","resourceVersion":"1.0","name":"graphic_73E37D9","spriteId":{"name":"sprt_TitleTerminals","path":"sprites/sprt_TitleTerminals/sprt_TitleTerminals.yy",},"headPosition":0.0,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"animationSpeed":1.0,"colour":4294967295,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":144.0,"y":128.0,},
        {"resourceType":"GMRSpriteGraphic","resourceVersion":"1.0","name":"graphic_27F17FC0","spriteId":{"name":"sprt_TitleTube","path":"sprites/sprt_TitleTube/sprt_TitleTube.yy",},"headPosition":0.0,"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"animationSpeed":1.0,"colour":4294967295,"inheritedItemId":null,"frozen":false,"ignore":false,"inheritItemSettings":false,"x":208.0,"y":96.0,},
      ],"visible":true,"depth":400,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Projectiles_fg","instances":[],"visible":true,"depth":200,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Liquids_fg","instances":[],"visible":true,"depth":300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"TileFadeObjects","instances":[],"visible":true,"depth":700,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade0","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":800,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade1","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":900,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade2","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1000,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fade3","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1100,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
      ],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"BTS_Tiles","instances":[],"visible":true,"depth":900,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg0","tilesetId":{"name":"ts_Ceres","path":"tilesets/ts_Ceres/ts_Ceres.yy",},"x":0,"y":0,"tiles":{"TileDataFormat":1,"SerialiseWidth":28,"SerialiseHeight":15,"TileCompressedData":[
-11,3,6,1,128,129,268435585,268435584,268435457,-10,268435459,-3,3,1,268435489,-8,536870914,6,268435490,128,129,268435585,268435584,34,-8,805306370,2,33,
268435459,-3,3,25,1,179,180,181,179,180,181,179,180,181,128,129,268435585,268435584,268435637,268435636,268435635,268435637,268435636,268435635,268435637,268435636,268435635,268435457,
268435459,-3,3,25,1,268435603,143,147,268435603,143,147,268435603,143,268435603,160,161,268435617,268435616,147,143,147,268435603,143,147,268435603,143,147,268435457,
268435459,-3,3,30,1,184,185,185,268435641,268435640,184,268435641,268435640,130,131,132,268435588,268435587,268435586,184,185,268435640,184,185,268435641,268435641,268435640,268435457,
268435459,3,536870914,536870914,268435490,216,-3,0,14,268435672,216,0,268435672,162,163,164,268435620,268435619,268435618,216,0,268435672,216,-3,0,4,268435672,34,
805306370,536870914,-3,0,25,536871094,536871095,268435671,0,268435670,536871094,805306551,805306550,0,136,134,268435590,268435592,0,536871094,536871095,805306550,214,0,215,805306551,805306550,0,
-2147483648,-2147483648,-5,0,3,536871126,0,805306582,-5,0,2,171,268435627,-5,0,3,536871126,0,805306582,-3,0,-2,-2147483648,8,352,353,354,0,
0,536871094,805306551,805306550,-5,0,19,171,268435627,0,21,22,23,0,536871094,536871095,805306550,0,0,268435810,268435809,268435808,384,385,386,387,-5,0,
10,18,19,20,0,171,268435627,0,53,54,55,-5,0,9,268435843,268435842,268435841,268435840,2,417,418,419,420,-4,0,10,50,51,
52,168,169,268435625,268435624,85,86,87,-4,0,10,268435876,268435875,268435874,268435873,2,3,3,450,418,452,-4,0,10,82,83,84,536871072,
536871073,805306529,805306528,117,118,119,-4,0,4,268435908,268435874,268435906,268435459,-4,3,2,450,484,-3,0,19,107,108,109,0,536871040,536871041,805306497,
805306496,0,105,106,75,76,0,0,268435940,268435906,268435459,268435459,-5,3,1,516,-6,2,6,805306402,536871040,536871041,805306497,805306496,536870946,-5,2,2,
268435458,268435972,-3,268435459,-12,3,6,1,536871040,536871041,805306497,805306496,268435457,-11,3,],},"visible":true,"depth":1000,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg1","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1100,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg2","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1200,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
        {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Tiles_fg3","tilesetId":null,"x":0,"y":0,"tiles":{"SerialiseWidth":0,"SerialiseHeight":0,"TileSerialiseData":[
],},"visible":true,"depth":1300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
      ],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Liquids","instances":[],"visible":true,"depth":1400,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"WorldObjects","instances":[],"visible":true,"depth":1800,"userdefinedDepth":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
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
    {"resourceType":"GMRBackgroundLayer","resourceVersion":"1.0","name":"Background","spriteId":{"name":"bg_Ceres1","path":"sprites/bg_Ceres1/bg_Ceres1.yy",},"colour":4294967295,"x":16,"y":0,"htiled":true,"vtiled":true,"hspeed":0.0,"vspeed":0.0,"stretch":false,"animationFPS":15.0,"animationSpeedType":0,"userdefinedAnimFPS":false,"visible":true,"depth":2300,"userdefinedDepth":false,"inheritLayerDepth":true,"inheritLayerSettings":false,"gridX":16,"gridY":16,"layers":[],"hierarchyFrozen":false,"effectEnabled":true,"effectType":null,"properties":[],},
  ],
  "inheritLayers": false,
  "creationCodeFile": "",
  "inheritCode": true,
  "instanceCreationOrder": [
    {"name":"inst_12E9934F","path":"rooms/rm_MainMenu/rm_MainMenu.yy",},
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