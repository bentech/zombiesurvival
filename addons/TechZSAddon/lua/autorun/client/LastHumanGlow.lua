/*		
	LastHuman Glow
	Written by Bentech
*/
local function LastHuman(pl)
	hook.Add( "PreDrawHalos", "LastHumanHalo", LastHumanHalo );
end
hook.Add("LastHuman", "LastHumanGlow", LastHuman)


local function LastHumanHalo()

	if !GAMEMODE.TheLastHuman then

		hook.Remove( "PreDrawHalos", "LastHumanHalo" );
		return;
	end

    effects.halo.Add({GAMEMODE.TheLastHuman}, Color(0, 0, 255), 5, 5, 2, true)
end