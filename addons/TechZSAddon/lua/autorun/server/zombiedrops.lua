/*		
	Zombie Drops Addon
	Written by Bentech

	Ammo Types are in gamemodes/zombiesurvival/zombiesurvival.fgd
*/


local drops = {
	{rarity=0.6, items={{ent="prop_ammo", SetAmmoType="pistol", SetAmmo=15}}},--Pistol Small
	{rarity=0.05, items={{ent="prop_ammo", SetAmmoType="pistol", SetAmmo=50}}},--Pistol Large
	{rarity=0.5, items={{ent="prop_ammo", SetAmmoType="smg1", SetAmmo=15}}},--Smg Small
	{rarity=0.02, items={{ent="prop_ammo", SetAmmoType="smg1", SetAmmo=50}}},--Smg Large
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="ar2", SetAmmo=15}}},--Assault
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="buckshot", SetAmmo=10}}},--Shotgun
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="357", SetAmmo=10}}},--Rifle
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="XBowBolt", SetAmmo=10}}},--Crossbow
	{rarity=0.1, items={{ent="prop_ammo", SetAmmoType="grenade", SetAmmo=1}}},--Grenade
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="SniperRound", SetAmmo=5}}},--Sniper
	{rarity=0.03, items={{ent="prop_ammo", SetAmmoType="SniperRound", SetAmmo=25}}},--Sniper
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="Battery", SetAmmo=50}}},--Medic
	{rarity=0.4, items={{ent="prop_ammo", SetAmmoType="GaussEnergy", SetAmmo=10}}},--Nail
	{rarity=0.6, items={{ent="prop_ammo", SetAmmoType="stone", SetAmmo=1}}},--Stones
	{rarity=0.005, items={{ent="prop_ammo", SetAmmoType="thumper", SetAmmo=100}}},--Turret	
}

local noDropRate = 10;--Lower numbers drop less
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