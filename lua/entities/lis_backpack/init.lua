AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel(LIS.CONFIG.DropInventoryModel)
    self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)	
	self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    if LIS.CONFIG.DropInventoryTimer > 0 then 
        timer.Simple(LIS.CONFIG.DropInventoryTimer, function() 
            if self and self:IsValid() then self:Remove() end
        end)
    end
end

function ENT:Use(ply, caller)
    PrintTable(self.Table)
end

--function ENT:StartTouch(ent)
--end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    local typ = dmg:GetDamageType()
    if bit.band(typ, bit.bor(DMG_FALL, DMG_VEHICLE, DMG_DROWN, DMG_RADIATION, DMG_PHYSGUN)) > 100 then return end

    self:Remove()
end

function ENT:onPlayerDisconnected(ply)
    self:Remove()
end