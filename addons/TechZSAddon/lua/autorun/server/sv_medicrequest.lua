/*		
	Medic Request
	Written by Bentech

    Call for medic (written for ZS)
    REMOVE hook.Remove("PostDrawEffects", "RenderHalos") from nixthelag.lua for ZS
*/
local auraTime = 19 --Should be 1 less that cl_medicrequest
local function init()
	util.AddNetworkString( "tz_RequestingMedic" )
end
hook.Add( "Initialize", "medicInit", init )

local lastUsed = {}
AddCSLuaFile("../client/cl_medicrequest.lua")
function callMedic(pl,cmd,args)

	if(pl:Health() > pl:GetMaxHealth() -15)then
		return
	end

	local ls = lastUsed[pl:UserID()]
	if(ls != nil && os.difftime( os.time(), lastUsed[pl:UserID()] ) < auraTime)then--Do we trust the client? no
		return
	end

	lastUsed[pl:UserID()] = os.time()

	local medics = {}
	for _, v in pairs( player.GetAll() ) do
		if(v:HasWeapon("weapon_zs_medicalkit") || v:HasWeapon("weapon_zs_medicgun"))then
      		table.insert(medics, v)
		end
	end

	net.Start( "tz_RequestingMedic" )
		net.WriteEntity( pl )
	net.Send(medics)	


end
concommand.Add( "tz_RequestMedic", callMedic)