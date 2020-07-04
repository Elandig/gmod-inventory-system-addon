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

SWEP.Weight	= 1 
SWEP.AutoSwitchTo	= false
SWEP.AutoSwitchFrom	= false

SWEP.Slot	= 0
SWEP.SlotPos	= 1
SWEP.DrawCrosshair	= true

SWEP.DrawAmmo = true
SWEP.HoldType = "camera"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.UseHands = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

if SERVER then
	function SWEP:PrimaryAttack()
		self.Owner:LIS_PickupItem()
	end
	
	function SWEP:SecondaryAttack()
		self.Owner:ConCommand( "lis_inventory_open" )
	end
	
end

function SWEP:GetViewModelPosition(position, angle)
	self:SetWeaponHoldType("normal")
end