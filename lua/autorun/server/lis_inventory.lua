util.AddNetworkString("LIS_DropInventoryItem")
util.AddNetworkString("LIS_DrawPlayerInventory")

net.Receive("LIS_DropInventoryItem", function(len, ply)
    local id = net.ReadUInt(16)

    LIS_DropItem(ply, "lis_inventory_drop", {id})
end)

function LIS_OpenInventory(ply)
    local data = {}
    for _,v in pairs(ply:LIS_GetInventory()) do
        table.insert( data, {v.Class, v.Model})
    end

    net.Start("LIS_DrawPlayerInventory")
    net.WriteUInt(LIS.CONFIG.InventoryStyle, 16)
    net.WriteTable(data)
	net.Send(ply)
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

local meta = FindMetaTable("Player")

function meta:LIS_ValidateInventory()
    if !(self.LIS) then self.LIS = {Inventory = {}} end
end

function meta:LIS_AddInventoryItem(tbl)
    self:LIS_ValidateInventory()
    table.insert( self.LIS.Inventory, tbl)
    self:LIS_SaveInventory()
end

concommand.Add("lis_inventory_delete", LIS_DeleteInventory)
concommand.Add("lis_inventory_drop", LIS_DropItem)
concommand.Add("lis_inventory_open", LIS_OpenInventory)