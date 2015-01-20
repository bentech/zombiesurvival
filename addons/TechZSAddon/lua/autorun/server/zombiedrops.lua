/*		
	Zombie Drops Addon
	Written by Bentech

	Ammo Types are in gamemodes/zombiesurvival/zombiesurvival.fgd
*/
  local drops = {
--------------------------------------Ammo------------------------------------------------------

{rarity=0.5, items={{ent="prop_ammo", SetAmmoType="pistol", SetAmmo=12}}},--Pistol Small
{rarity=0.3, items={{ent="prop_ammo", SetAmmoType="pistol", SetAmmo=24}}},--Pistol Mid
{rarity=0.1, items={{ent="prop_ammo", SetAmmoType="pistol", SetAmmo=72}}},--Pistol Large

{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="smg1", SetAmmo=30}}},--Smg Small
{rarity=0.25, items={{ent="prop_ammo", SetAmmoType="smg1", SetAmmo=60}}},--Smg Mid
{rarity=0.08, items={{ent="prop_ammo", SetAmmoType="smg1", SetAmmo=180}}},--Smg Large

{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="ar2", SetAmmo=30}}},--Assault Small
{rarity=0.25, items={{ent="prop_ammo", SetAmmoType="ar2", SetAmmo=60}}},--Assault Mid
{rarity=0.08, items={{ent="prop_ammo", SetAmmoType="ar2", SetAmmo=180}}},--Assault Large

{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="buckshot", SetAmmo=8}}},--Shotgun Small
{rarity=0.25, items={{ent="prop_ammo", SetAmmoType="buckshot", SetAmmo=16}}},--Shotgun Mid
{rarity=0.08, items={{ent="prop_ammo", SetAmmoType="buckshot", SetAmmo=48}}},--Shotgun Large

{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="357", SetAmmo=6}}},--Rifle Small
{rarity=0.25, items={{ent="prop_ammo", SetAmmoType="357", SetAmmo=12}}},--Rifle Mid
{rarity=0.08, items={{ent="prop_ammo", SetAmmoType="357", SetAmmo=36}}},--Rifle Large

--------------------------------------Usables---------------------------------------------------

{rarity=0.5, items={{ent="prop_weapon", SetWeaponType="weapon_zs_stone"}}},--Stone
{rarity=0.015, items={{ent="prop_weapon", SetAmmoType="weapon_zs_grenade"}}},--Grenade

{rarity=0.2, items={{ent="prop_ammo", SetAmmoType="Battery", SetAmmo=20}}},--Medic Power
{rarity=0.2, items={{ent="prop_ammo", SetAmmoType="GaussEnergy", SetAmmo=5}}},--Nail

{rarity=0.5, items={{ent="prop_weapon", SetWeaponType="weapon_zs_messagebeacon"}}},--Be
{rarity=0.15, items={{ent="prop_weapon", SetWeaponType="weapon_zs_boardpack"}}},--Junkpack
{rarity=0.01, items={{ent="prop_weapon", SetWeaponType="weapon_zs_barricadekit"}}},--Aegis

--------------------------------------Weapons---------------------------------------------------

{rarity=0.15, items={{ent="prop_weapon", SetWeaponType="weapon_zs_peashooter"}}},--Peashooter
{rarity=0.1, items={{ent="prop_weapon", SetWeaponType="weapon_zs_battleaxe"}}},--Battleaxe

{rarity=0.25, items={{ent="prop_weapon", SetWeaponType="weapon_zs_knife"}}},--Knife
{rarity=0.15, items={{ent="prop_weapon", SetWeaponType="weapon_zs_fryingpan"}}},--Frying Pan
{rarity=0.1, items={{ent="prop_weapon", SetWeaponType="weapon_zs_crowbar"}}},--Crowbar
{rarity=0.05, items={{ent="prop_weapon", SetWeaponType="weapon_zs_axe"}}},--Axe
{rarity=0.05, items={{ent="prop_weapon", SetWeaponType="weapon_zs_hook"}}},--Meathook
{rarity=0.05, items={{ent="prop_weapon", SetWeaponType="weapon_zs_sledgehammer"}}},--Sledgehammer
{rarity=0.025, items={{ent="prop_weapon", SetWeaponType="weapon_zs_hammer"}}},--Hammer
}

local noDropRate = 2;--Lower numbers drop less

function OnZombieDeath(pl, attacker, inflictor, dmginfo, headshot, suicide)

	math.randomseed( os.time() )
	local drop = nil
	local random = math.random()--Returns number between 0and1
	
	if headshot then
		random = random - 0.05 --Headshot bonus
	end
	
	if suicide then
		random = random + 0.05
	end

	for i=1,noDropRate do--tries finding a random drop with noDropRate
	
		local item = drops[ math.random( #drops ) ] 
		print( "checking" )
		print( item.rarity)
		if item.rarity > random then
			drop = item
			break
		end
		
	end

	if drop == nil then
		return --Don't drop anything
	end
	
	for _,item in pairs(drop.items) do
	
		if item.ent then
			local ent = ents.Create(item.ent)
			if ent:IsValid() then
				if(item.SetAmmoType)then
					ent:SetAmmoType(item.SetAmmoType)
				end
				if(item.SetWeaponType)then
					ent:SetWeaponType(item.SetWeaponType)
				end

				if(item.SetAmmo)then
					ent:SetAmmo(item.SetAmmo)
				end
				if(item.SetModel)then
					ent:SetModel(item.SetModel)
				end
				ent:Spawn()
				
				--Make it fall				
				local vPos = pl:GetPos()
				local vVel = pl:GetVelocity()
				local zmax = pl:OBBMaxs().z * 0.75
				ent:SetPos(vPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(2, zmax)))
				ent:SetAngles(VectorRand():Angle())
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:AddAngleVelocity(Vector(math.Rand(-720, 720), math.Rand(-720, 720), math.Rand(-720, 720)))
					phys:ApplyForceCenter(phys:GetMass() * (math.Rand(32, 328) * VectorRand():GetNormalized() + vVel))
				end
				
			end
		
		end
	
	end
end
hook.Add("PostHumanKilledZombie", "TechZSHZK", OnZombieDeath);