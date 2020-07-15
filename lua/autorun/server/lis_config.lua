-- Server-side CFG

LIS = {}
LIS.CONFIG = {}

LIS.CONFIG.SavePath = "lucid_inventory"
LIS.CONFIG.PickupSound = "items/ammo_pickup.wav"
LIS.CONFIG.InventoryStyle = 1
LIS.CONFIG.PickupDistance = 100
LIS.CONFIG.SpawnWithSWEP = true -- Give Inventory SWEP on spawn

LIS.CONFIG.AllowDropAmmo = true
LIS.CONFIG.MaxAmmoBoxCount = 5

LIS.CONFIG.DisallowPickupForEntityGroup = {"func_", "door_", "prop_", "npc_", "env_", "path_", "edit_"}
LIS.CONFIG.DisallowPickup = {	
    ["fadmin_jail"] = true,
    ["meteor"] = true,
    ["door"] = true,
    ["player"] = true,
    ["beam"] = true,
    ["worldspawn"] = true,
    ["prop_physics"] = true,
    ["money_printer"] = true,
    ["gunlab"] = true,
    ["prop_dynamic"] = true,
    ["prop_vehicle_prisoner_pod"] = true,
    ["keypad_wire"] = true,
    ["gmod_button"] = true,
    ["gmod_rtcameraprop"] = true,
    ["gmod_cameraprop"] = true,
    ["gmod_dynamite"] = true,
    ["gmod_thruster"] = true,
    ["gmod_light"] = true,
    ["gmod_lamp"] = true,
    ["gmod_emitter"] = true,
    ["sent_ball"] = true
}

----- Drop Inventory On Death -----
LIS.CONFIG.DropInventoryOnDeath = true
LIS.CONFIG.DropInventoryModel = "models/Items/item_item_crate.mdl"
LIS.CONFIG.DropInventoryTimer = 10