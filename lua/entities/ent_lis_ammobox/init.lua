AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	
	if self.AmmoType == "AR2" then
		self:SetModel("models/Items/combine_rifle_cartridge01.mdl")  -- AR2
	elseif self.AmmoType == "Pistol" then
		self:SetModel("models/Items/BoxSRounds.mdl")  				-- Pistol
	elseif self.AmmoType == "Buckshot" then
		self:SetModel("models/Items/BoxBuckshot.mdl") 				-- Buckshot
	elseif self.AmmoType == "357" then
		self:SetModel("models/Items/357ammo.mdl")     				-- 357
	elseif self.AmmoType == "SMG1" then
		self:SetModel("models/Items/BoxMRounds.mdl")					-- SMG1
	elseif self.AmmoType == "XBowBolt" then
		self:SetModel("models/Items/CrossbowRounds.mdl")				-- Crossbow Bolts
	elseif self.AmmoType == "RPG_Round" then
		self:SetModel("models/weapons/w_missile_closed.mdl")			-- RPG Rocket
	else
		self:SetModel("models/Items/BoxMRounds.mdl")					-- Other Ammo
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply, caller)
	if (ply:IsPlayer()) then
		ply:GiveAmmo(self.AmmoCount, self.AmmoType)
		self:Remove()
	end
	if !(self:GetOwner():IsValid()) then return false end
	self:GetOwner().LIS.Ammo = self:GetOwner().LIS.Ammo - 1
	print(self:GetOwner().LIS.Ammo)
end