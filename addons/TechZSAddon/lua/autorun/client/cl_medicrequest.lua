/*		
	Medic Request
	Written by Bentech

    Call for medic (written for ZS)
*/
local auraTime = 20;
local medicTrigger = false

local needs = {}
function medicMove()

	if vgui.CursorVisible() then
		return
	end

	if input.IsKeyDown(KEY_M) then
		if !medicTrigger then
			medicTrigger = true
			callMedic()
		end
	elseif medicTrigger then
		medicTrigger = false
	end
	
	if #needs > 0 then
		for i=#needs,1,-1 do
			local npl = needs[i].npl
			if ( npl:Team() != TEAM_HUMAN 
				|| npl:Health() >= npl:GetMaxHealth() -15
				|| os.difftime( os.time(), needs[i].time ) > auraTime) then
		        table.remove(needs, i)
			end
		end
	end


end
hook.Add("Think", "medicMove", medicMove)

local sounds = 
{
	"vo/npc/male01/imhurt01.wav",
	"vo/npc/male01/imhurt02.wav",
	"vo/npc/female01/imhurt01.wav",
	"vo/npc/female01/imhurt02.wav",
}
local lastUsed = 0
function callMedic()
	if(LocalPlayer():Health() > LocalPlayer():GetMaxHealth() -15)then
		return
	end
	if(os.difftime( os.time(), lastUsed ) > auraTime)then
		LocalPlayer():EmitSound(table.Random(sounds), 70, math.random(60,100),1,CHAN_AUTO)
		LocalPlayer():ConCommand("tz_RequestMedic");
		lastUsed = os.time()
	end
end
function calledMedic(  )
	local npl = net.ReadEntity()
	if(npl != LocalPlayer())then
		npl:EmitSound(table.Random(sounds), 70, math.random(60,100),1,CHAN_AUTO)
	end
	table.insert(needs, {npl=npl, time= os.time()})
	
end
net.Receive( "tz_RequestingMedic", calledMedic)

local xl = 1
local neg = true
local function MedicHalo()
	if #needs == 0 then
		return
	end
	if(neg)then
		xl=xl-0.1
	else
		xl=xl+0.1
	end
	for k, v in pairs(needs) do
		local green = v.npl:Health() / v.npl:GetMaxHealth()		
    	effects.halo.Add({v.npl}, Color(255 * (1-green), 255 * green, 0, 200 * (1-green)), xl, xl, 1, true, true)
	end
    if xl < 0 || xl > 10 then
    	neg = not neg
    end

end
hook.Add( "PreDrawHalos", "MedicHalo", MedicHalo );
