util.AddNetworkString("LIS_DropInventoryItem")
util.AddNetworkString("LIS_DrawPlayerInventory")
util.AddNetworkString("LIS_InventoryItemDropFailed")

hook.Add("PlayerSpawn", "LIS_GiveSWEP", function(ply)
    if LIS.CONFIG.SpawnWithSWEP then
        ply:Give("swep_inventory")
    end
end)

hook.Add("PlayerDeath", "LIS_DropInventoryOnDeath", function(ply, inflictor,attacker)
    if LIS.CONFIG.DropInventoryOnDeath then 
        local backpack = ents.Create("lis_backpack")
        backpack.Table = ply:LIS_GetInventory()
        backpack:SetPos(ply:GetPos())
        backpack:Spawn()

        LIS_DeleteInventory(ply)
    end
end)

net.Receive("LIS_DropInventoryItem", function(len, ply)
    local id = net.ReadUInt(16)

    LIS_DropItem(ply, "lis_inventory_drop", {id})
end)

local function formatInventoryData(ply)
    local data = {}
    for _,v in pairs(ply:LIS_GetInventory()) do
        table.insert( data, {v.Class, v.Model})
    end
    return data
end

function LIS_OpenInventory(ply)
    local data = formatInventoryData(ply)

    net.Start("LIS_DrawPlayerInventory")
    net.WriteUInt(LIS.CONFIG.InventoryStyle, 16)
    net.WriteTable(data)
	net.Send(ply)
end

function LIS_DropItem(ply, cmd, args)
    local id = tonumber( args[1], 10 )
    local item = ply:LIS_GetInventory()[id]

    if !id or ply:LIS_GetInventory()[id] == nil then

        local data = formatInventoryData(ply)
        net.Start("LIS_InventoryItemDropFailed")
        net.WriteTable(data)
        net.Send(ply)
        return

    end

    local Entity = ents.Create(item.Class)
    duplicator.DoGeneric(Entity, item)
    Entity:Spawn()
    Entity:Activate()

    duplicator.DoGenericPhysics(Entity, ply, item)
    table.Merge(Entity:GetTable(), item)

    local tracedata = {}
    tracedata.start = ply:EyePos()
    tracedata.endpos = tracedata.start + ply:GetAimVector() * 80
    tracedata.filter = ply

	local tr = util.TraceLine(tracedata)

    Entity:SetPos(tr.HitPos)

    table.remove( ply.LIS.Inventory, id)
    ply:LIS_SaveInventory()
end

function LIS_DropAmmo(ply)
    if !LIS.CONFIG.AllowDropAmmo then return false end
    if !ply.LIS.Ammo then ply.LIS.Ammo = 0 end
    if  ply.LIS.Ammo >= LIS.CONFIG.MaxAmmoBoxCount then return false end

    local ammo = "Pistol"
    local count = 5

    local Entity = ents.Create("ent_lis_ammobox")
    Entity.AmmoType = ammo
	Entity.AmmoCount = count
    Entity:SetOwner(ply)
    Entity:Spawn()
    Entity:Activate()
    
    local tracedata = {}
    tracedata.start = ply:EyePos()
    tracedata.endpos = tracedata.start + ply:GetAimVector() * 80
    tracedata.filter = ply
    local tr = util.TraceLine(tracedata)
    Entity:SetPos(tr.HitPos)

    ply.LIS.Ammo = ply.LIS.Ammo + 1
end

function LIS_DeleteInventory(ply)
    ply.LIS.Inventory = {}
    ply:LIS_SaveInventory()
    ply:LIS_CreateInventory()
end

local meta = FindMetaTable("Player")

function meta:LIS_ValidateInventory()
    if !(self.LIS) then self.LIS = {Inventory = {}} end
end

function meta:LIS_PickupItem()
    local ent = self:GetEyeTrace().Entity
    if !ent or !ent:IsValid() or ent:IsPlayer() or ent:IsNPC() then return false end

    if self:GetPos():Distance(ent:GetPos()) < LIS.CONFIG.PickupDistance then
        local entity = duplicator.CopyEntTable( ent )
        for _, v in pairs(LIS.CONFIG.DisallowPickupForEntityGroup) do
            if string.find(entity.Class, v) then return false end
        end
        for _,v in pairs(LIS.CONFIG.DisallowPickup) do
            if entity.Class == v then return false end
        end

        self:LIS_AddInventoryItem(entity)

        ent:Remove()
        self:EmitSound(LIS.CONFIG.PickupSound, 100, 100)
    end
end

function meta:LIS_AddInventoryItem(tbl)
    self:LIS_ValidateInventory()
    table.insert( self.LIS.Inventory, tbl)
    self:LIS_SaveInventory()
end

concommand.Add("lis_inventory_delete", LIS_DeleteInventory)
concommand.Add("lis_inventory_drop", LIS_DropItem)
concommand.Add("lis_inventory_open", LIS_OpenInventory)
concommand.Add("lis_inventory_dropammo", LIS_DropAmmo)
