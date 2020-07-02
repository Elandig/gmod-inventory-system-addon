util.AddNetworkString("LIS_DropInventoryItem")

hook.Add("PlayerUse", "LIS_PickupEntity", function(ply, ent)
    if ply.LIS.CanUse then 
        ply.LIS.CanUse = false
        local entity = duplicator.CopyEntTable( ent )
        for _, v in pairs(LIS.CONFIG.DisallowPickupForEntityGroup) do
            if string.find(entity.Class, v) then return false end
        end
        for _,v in pairs(LIS.CONFIG.DisallowPickup) do
            if entity.Class == v then return false end
        end

        ply:LIS_AddInventoryItem(entity)
        ent:Remove()
        timer.Simple(1, function() if !ply.LIS.CanUse then ply.LIS.CanUse = true end end)
    end
end)

net.Receive("LIS_DropInventoryItem", function(len, ply)
    local id = net.ReadUInt(16)
    
    LIS_DropItem(ply, "lis_inventory_drop", {id})
end)

local meta = FindMetaTable("Player")

function meta:LIS_AddInventoryItem(tbl)
    table.insert( self.LIS.Inventory, tbl)

    self:LIS_SaveInventory()
end

function LIS_OpenInventory(ply)
    PrintTable(ply:LIS_GetInventory())
end

function LIS_DropItem(ply, cmd, args)
    local id = tonumber( args[1], 10 )
    if !id or ply:LIS_GetInventory()[id] == nil then print("Nope!") return end

    local pos = ply:EyePos()
	local tracedata = {start = pos, endpos = pos+(ply:GetForward()*40), filter = ply}
	local tr = util.TraceLine(tracedata)

    local Entity = duplicator.CreateEntityFromTable( ply, ply:LIS_GetInventory()[id])
    Entity:SetPos(tr.HitPos + tr.HitNormal*10)
    Entity:Spawn()
    Entity:Activate() 
    table.remove( ply.LIS.Inventory, id)
    ply:LIS_SaveInventory()
end

function LIS_DeleteInventory(ply)
    if ply:IsAdmin() then ply.LIS.Inventory = {} end
    ply:LIS_SaveInventory()
    ply:LIS_CreateInventory()
end

concommand.Add("lis_inventory_delete", LIS_DeleteInventory)
concommand.Add("lis_inventory_drop", LIS_DropItem)
concommand.Add("lis_inventory_open", LIS_OpenInventory)