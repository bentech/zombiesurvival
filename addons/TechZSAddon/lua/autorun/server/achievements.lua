/*		
	ZS Achievements
	Written by Bentech

    Based on HonorableMentions
    Version 2
*/


/* BenSQL */
local function Initialize()

	if !(sql.TableExists("BenSQL_achievements"))then
		sql.Query( "CREATE TABLE BenSQL_achievements ( UniqueID string, achievementName string, achievementCount int, achievementTotal int  ); PRIMARY KEY (UniqueID, achievementName);" )
	end

end
hook.Add( "Initialize", "BenSQLInit", Initialize )

function IncreaseAchievementCount( pl, achievementName, amount )

	local steamID = pl:SteamID()

	local result = sql.QueryValue("SELECT achievementCount FROM BenSQL_achievements WHERE achievementName = '"..achievementName.."' AND UniqueID = '"..steamID.."'")
	if (result) then
		sql.Query( "UPDATE BenSQL_achievements SET achievementCount = achievementCount + 1,achievementTotal = achievementTotal + "..amount.." WHERE achievementName = '"..achievementName.."' AND UniqueID = '"..steamID.."'" )
		return result + 1;
	else
		sql.Query( "INSERT INTO BenSQL_achievements (`UniqueID`, `achievementName`, `achievementCount`, `achievementTotal`)VALUES ('"..steamID.."', '"..achievementName.."', 1, "..amount..")" )
		return 1;
	end
end	

local function handleMentions()

	for i, tab in pairs(GAMEMODE.CachedHMs) do

		local mentiontab = GAMEMODE.HonorableMentions[tab[2]]
		if mentiontab then 
			local pl = tab[1]
			local timesAchieved = IncreaseAchievementCount(pl, i, tonumber(tab[3]))
			local points = 10
			if(timesAchieved % 100 == 0)then
				points = 150 //Every 100 times they achvie the same thing they get a 150 points
			end
			pl:PS_GivePoints(points);
			pl:PrintMessage( 4 , "You've had an Honorable Mention of ".. mentiontab.Name .. " and earned "..points.." points. ("..timesAchieved..")" );
		end

	end

end
hook.Add("PostDoHonorableMentions", "TMHonorableMentions", handleMentions);