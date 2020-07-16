{
    "id": "9334928a-1721-428d-b2e4-9895247009be",
    "modelName": "GMExtension",
    "mvc": "1.2",
    "name": "discordRP",
    "IncludedResources": [
        
    ],
    "androidPermissions": [
        
    ],
    "androidProps": false,
    "androidactivityinject": "",
    "androidclassname": "",
    "androidinject": "",
    "androidmanifestinject": "",
    "androidsourcedir": "",
    "author": "",
    "classname": "",
    "copyToTargets": 64,
    "date": "2019-40-03 04:03:20",
    "description": "",
    "exportToGame": true,
    "extensionName": "",
    "files": [
        {
            "id": "43c55acc-7108-4232-aa13-59790358c453",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": 64,
            "filename": "RPDLL.dll",
            "final": "",
            "functions": [
                {
                    "id": "6a93c357-16d4-4f0f-95a6-6569170ebde7",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "test_linkage",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "test_linkage",
                    "returnType": 2
                },
                {
                    "id": "79a9d707-02df-498c-b1ea-5fc8bd61d61b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "shutdown_rpc",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "discord_stop",
                    "returnType": 2
                },
                {
                    "id": "65f67975-64af-4ca1-9336-57a6a5f959a7",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        1
                    ],
                    "externalName": "InitDiscord",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "discord_start",
                    "returnType": 2
                },
                {
                    "id": "798de678-d526-431f-805f-2479fbfc20cc",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "UpdatePresence",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "discord_update",
                    "returnType": 2
                },
                {
                    "id": "9e528f4a-b6d9-4064-a4d3-f9096535316d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        1,
                        1
                    ],
                    "externalName": "stateDiscord",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "discord_update_text",
                    "returnType": 2
                },
                {
                    "id": "e9c99556-5cb4-4d34-bdb7-3c509e5fe93a",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        1,
                        1,
                        1,
                        1
                    ],
                    "externalName": "imageDiscord",
                    "help": "",
                    "hidden": false,
                    "kind": 1,
                    "name": "discord_update_image",
                    "returnType": 2
                }
            ],
            "init": "",
            "kind": 1,
            "order": [
                "6a93c357-16d4-4f0f-95a6-6569170ebde7",
                "79a9d707-02df-498c-b1ea-5fc8bd61d61b",
                "65f67975-64af-4ca1-9336-57a6a5f959a7",
                "798de678-d526-431f-805f-2479fbfc20cc",
                "9e528f4a-b6d9-4064-a4d3-f9096535316d",
                "e9c99556-5cb4-4d34-bdb7-3c509e5fe93a"
            ],
            "origname": "",
            "uncompress": false
        }
    ],
    "gradleinject": "",
    "helpfile": "",
    "installdir": "",
    "iosProps": false,
    "iosSystemFrameworkEntries": [
        
    ],
    "iosThirdPartyFrameworkEntries": [
        
    ],
    "iosdelegatename": "",
    "iosplistinject": "",
    "license": "",
    "maccompilerflags": "",
    "maclinkerflags": "",
    "macsourcedir": "",
    "options": null,
    "optionsFile": "options.json",
    "packageID": "",
    "productID": "",
    "sourcedir": "",
    "supportedTargets": 64,
    "tvosProps": false,
    "tvosSystemFrameworkEntries": [
        
    ],
    "tvosThirdPartyFrameworkEntries": [
        
    ],
    "tvosclassname": "",
    "tvosdelegatename": "",
    "tvosmaccompilerflags": "",
    "tvosmaclinkerflags": "",
    "tvosplistinject": "",
    "version": "0.0.1"
}