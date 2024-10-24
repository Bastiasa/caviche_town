{
  "$GMRoom":"v1",
  "%Name":"rm_multiplayer",
  "creationCodeFile":"",
  "inheritCode":false,
  "inheritCreationOrder":false,
  "inheritLayers":false,
  "instanceCreationOrder":[
    {"name":"inst_686F328D_1","path":"rooms/rm_multiplayer/rm_multiplayer.yy",},
    {"name":"inst_74B0FC76_1","path":"rooms/rm_multiplayer/rm_multiplayer.yy",},
    {"name":"inst_4F936275_1","path":"rooms/rm_multiplayer/rm_multiplayer.yy",},
    {"name":"inst_62436046_1","path":"rooms/rm_multiplayer/rm_multiplayer.yy",},
  ],
  "isDnd":false,
  "layers":[
    {"$GMRInstanceLayer":"","%Name":"online_management","depth":0,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"online_management","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRLayer":"","%Name":"gameplay","depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
        {"$GMRInstanceLayer":"","%Name":"characters","depth":200,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
            {"$GMRInstance":"v1","%Name":"inst_4F936275_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_4F936275_1","objectId":{"name":"obj_player","path":"objects/obj_player/obj_player.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":800.0,"y":608.0,},
          ],"layers":[],"name":"characters","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
        {"$GMRInstanceLayer":"","%Name":"bullets","depth":300,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"bullets","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
      ],"name":"gameplay","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRLayer":"","%Name":"rocks","depth":400,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
        {"$GMRInstanceLayer":"","%Name":"rocks_collider","depth":500,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
            {"$GMRInstance":"v1","%Name":"inst_62436046_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_62436046_1","objectId":{"name":"obj_rocks","path":"objects/obj_rocks/obj_rocks.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":3.05,"scaleY":3.0444446,"x":0.0,"y":0.0,},
          ],"layers":[],"name":"rocks_collider","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
        {"$GMRAssetLayer":"","%Name":"rocks_bg","assets":[
            {"$GMRSpriteGraphic":"","%Name":"graphic_641E85F5_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_641E85F5_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":3.05,"scaleY":3.0444446,"spriteId":{"name":"spr_rocks_bg","path":"sprites/spr_rocks_bg/spr_rocks_bg.yy",},"x":0.0,"y":0.0,},
          ],"depth":600,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"rocks_bg","properties":[],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
      ],"name":"rocks","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
    {"$GMRLayer":"","%Name":"clouds","depth":700,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
        {"$GMRInstanceLayer":"","%Name":"clouds_colliders","depth":800,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
            {"$GMRInstance":"v1","%Name":"inst_74B0FC76_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_74B0FC76_1","objectId":{"name":"obj_clouds","path":"objects/obj_clouds/obj_clouds.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":3.05,"scaleY":3.0444446,"x":0.0,"y":0.0,},
          ],"layers":[],"name":"clouds_colliders","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
        {"$GMRAssetLayer":"","%Name":"clouds_bg","assets":[
            {"$GMRSpriteGraphic":"","%Name":"graphic_7A2EAE1D_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_7A2EAE1D_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":3.05,"scaleY":3.0444446,"spriteId":{"name":"bg","path":"sprites/bg/bg.yy",},"x":0.0,"y":0.0,},
          ],"depth":900,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"clouds_bg","properties":[],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
      ],"name":"clouds","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
    {"$GMRLayer":"","%Name":"city","depth":1000,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
        {"$GMRInstanceLayer":"","%Name":"city_colliders","depth":1100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
            {"$GMRInstance":"v1","%Name":"inst_686F328D_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_686F328D_1","objectId":{"name":"obj_city","path":"objects/obj_city/obj_city.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":3.0215137,"scaleY":3.0215137,"x":0.0,"y":0.0,},
          ],"layers":[],"name":"city_colliders","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
        {"$GMRAssetLayer":"","%Name":"city_bg","assets":[
            {"$GMRSpriteGraphic":"","%Name":"graphic_66BDCD5C_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_66BDCD5C_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":3.0,"scaleY":3.0444443,"spriteId":{"name":"Sprite93","path":"sprites/Sprite93/Sprite93.yy",},"x":0.0,"y":0.0,},
          ],"depth":1200,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"city_bg","properties":[],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
        {"$GMRAssetLayer":"","%Name":"city_bg_2","assets":[
            {"$GMRSpriteGraphic":"","%Name":"graphic_4ED5295A_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_4ED5295A_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":7.6771655,"scaleY":7.6666665,"spriteId":{"name":"city_paralax_01","path":"sprites/city_paralax_01/city_paralax_01.yy",},"x":0.0,"y":0.0,},
            {"$GMRSpriteGraphic":"","%Name":"graphic_744C2009_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_744C2009_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":7.6771655,"scaleY":7.6666665,"spriteId":{"name":"city_paralax_03","path":"sprites/city_paralax_03/city_paralax_03.yy",},"x":0.0,"y":0.0,},
            {"$GMRSpriteGraphic":"","%Name":"graphic_5B80F38_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_5B80F38_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":7.6771655,"scaleY":7.6666665,"spriteId":{"name":"city_paralax_02","path":"sprites/city_paralax_02/city_paralax_02.yy",},"x":0.0,"y":0.0,},
            {"$GMRSpriteGraphic":"","%Name":"graphic_661A28E0_1","animationSpeed":1.0,"colour":4294967295,"frozen":false,"headPosition":0.0,"ignore":false,"inheritedItemId":null,"inheritItemSettings":false,"name":"graphic_661A28E0_1","resourceType":"GMRSpriteGraphic","resourceVersion":"2.0","rotation":0.0,"scaleX":7.6771655,"scaleY":7.888889,"spriteId":{"name":"city_paralax_04","path":"sprites/city_paralax_04/city_paralax_04.yy",},"x":0.0,"y":-32.0,},
          ],"depth":1300,"effectEnabled":true,"effectType":"_filter_tintfilter","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"city_bg_2","properties":[
            {"name":"g_TintCol","type":1,"value":"#FF6B6B6B",},
          ],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
      ],"name":"city","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":false,},
    {"$GMRBackgroundLayer":"","%Name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":4278190080,"depth":1400,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Background","properties":[],"resourceType":"GMRBackgroundLayer","resourceVersion":"2.0","spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,},
  ],
  "name":"rm_multiplayer",
  "parent":{
    "name":"Salas",
    "path":"folders/Salas.yy",
  },
  "parentRoom":null,
  "physicsSettings":{
    "inheritPhysicsSettings":false,
    "PhysicsWorld":true,
    "PhysicsWorldGravityX":0.0,
    "PhysicsWorldGravityY":10.0,
    "PhysicsWorldPixToMetres":0.1,
  },
  "resourceType":"GMRoom",
  "resourceVersion":"2.0",
  "roomSettings":{
    "Height":1080,
    "inheritRoomSettings":false,
    "persistent":false,
    "Width":1920,
  },
  "sequenceId":null,
  "views":[
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":true,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings":{
    "clearDisplayBuffer":true,
    "clearViewBackground":false,
    "enableViews":true,
    "inheritViewSettings":false,
  },
  "volume":1.0,
}