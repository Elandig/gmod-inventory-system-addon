SWEP.Base = "weapon_base"
SWEP.PrintName	= "Inventory SWEP"
SWEP.Author	= "Barney & Elan"
SWEP.Instructions	= "LMB - Pickup item, RMB - open inventory"
SWEP.Category = "Lucid Inventory"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo	= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo	= "none"

SWEP.Weight	= 5 
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

SWEP.Slot	= 0
SWEP.SlotPos	= 1
SWEP.DrawCrosshair	= false

SWEP.DrawAmmo = true
SWEP.HoldType = "camera"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.UseHands = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self.Owner
		local ent = ply:GetEyeTrace().Entity

		if ply:GetPos():Distance(ent:GetPos()) < 100 then
			local entity = duplicator.CopyEntTable( ent )
			for _, v in pairs(LIS.CONFIG.DisallowPickupForEntityGroup) do
				if string.find(entity.Class, v) then return false end
			end
			for _,v in pairs(LIS.CONFIG.DisallowPickup) do
				if entity.Class == v then return false end
			end
	
			ply:LIS_AddInventoryItem(entity)

			ent:Remove()
			ply:EmitSound(LIS.CONFIG.PickupSound, 100, 100)
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self.Owner
		ply:ConCommand( "lis_inventory_open" )
	end
end

function SWEP:Think()
end	

function SWEP:OnRemove()
end

function SWEP:GetViewModelPosition(position, angle)
	self:SetWeaponHoldType("normal")
end