SWEP.Name = "Item"

SWEP.AnimPrefix = "none"
SWEP.HoldType = "normal"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "None"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "None"

SWEP.DrawCrosshair = false
SWEP.Primary.Sound = Sound("")

SWEP.WorldModel	= ""

SWEP.WalkSpeed = SPEED_NORMAL

function SWEP:Initialize()
end

function SWEP:SetWeaponHoldType()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:SelectWeapon("weapon_zs_fists")
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

