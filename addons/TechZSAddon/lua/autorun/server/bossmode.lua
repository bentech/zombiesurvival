/*		
	Boss Mode
	Written by Bentech

    Humans gain super weapons and zombies gain boss for a limited time
*/

/*Logic to start bossmode*/


/*Start Boss Mode*/
local function startBossMode()


	if GAMEMODE:GetEndRound() || GAMEMODE:GetWaveStart() == -1 then
		return;
	end

	--Give player extra ammo
	local humans = team.GetPlayers(TEAM_HUMAN)
	for _, pl in pairs(humans) do
		if pl:Team() == TEAM_HUMAN then

			--Get Ammo to give player
			local ammotype
			local wep = pl:GetActiveWeapon()
			if not wep:IsValid() then
				ammotype = "smg1"
			end

			if not ammotype then
				ammotype = wep:GetPrimaryAmmoTypeString()
				if not GAMEMODE.AmmoResupply[ammotype] then
					ammotype = "smg1"
				end
			end

			--Boost weapon
			wep:SetClip1(GAMEMODE.AmmoResupply[ammotype] * 4)
		end
	end


	--Spawn zombies as bosses (without zombie choice)

	--Find Boss

	local bossclasses = {}
	for _, classtable in pairs(GAMEMODE.ZombieClasses) do
		if classtable.Boss then
			table.insert(bossclasses, classtable.Index)
		end
	end

	local bossindex = bossclasses[2];



	local zombies = team.GetPlayers(TEAM_UNDEAD)
	for _, bossplayer in pairs(zombies) do
		local curclass = bossplayer.DeathClass or bossplayer:GetZombieClass()
		bossplayer:KillSilent()
		bossplayer:SetZombieClass(bossindex)
		bossplayer:DoHulls(bossindex, TEAM_UNDEAD)
		bossplayer.DeathClass = nil
		bossplayer:UnSpectateAndSpawn()
		bossplayer.DeathClass = curclass

		if not silent then
			net.Start("zs_boss_spawned")
				net.WriteEntity(bossplayer)
				net.WriteUInt(bossindex, 8)
			net.Broadcast()
		end

	end

end

/*Test Command*/
local function testBossMode(pl)

	if(!pl:IsSuperAdmin() || !pl:IsUserGroup("DEVELOPER"))then
		return
	end

 	startBossMode();

end
concommand.Add("tm_bossmode", testBossMode);