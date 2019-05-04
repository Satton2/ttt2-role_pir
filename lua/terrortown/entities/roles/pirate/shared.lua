if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_spy.vmt")
end

-- creates global var "TEAM_PIRATE" and other required things
-- TEAM_[name], data: e.g. icon, color,...
roles.InitCustomTeam(ROLE.name, { -- this creates var "TEAM_JESTER"
		icon = "vgui/ttt/dynamic/roles/icon_spy",
		color = Color(207, 148, 68, 255)
})

ROLE.color = Color(207, 148, 68, 255) -- ...
ROLE.dkcolor = Color(207, 148, 68, 255) -- ...
ROLE.bgcolor = Color(207, 148, 68, 255) -- ...
ROLE.abbr = "pir" -- abbreviation
ROLE.defaultTeam = TEAM_PIRATE -- the team name: roles with same team name are working together
ROLE.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
ROLE.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
ROLE.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
ROLE.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
ROLE.unknownTeam = true -- player don't know their teammates
ROLE.preventWin = true
ROLE.avoidTeamIcons = false

ROLE.conVarData = {
	pct = 0.17, -- necessary: percentage of getting this role selected (per player)
	maximum = 1, -- maximum amount of roles in a round
	random = 50,
	minPlayers = 7, -- minimum amount of players until this role is able to get selected
	togglable = true, -- option to toggle a role for a client if possible (F1 menu)
}

if CLIENT then -- just on client and first init !
	-- if sync of roles has finished
	hook.Add("TTT2FinishedLoading", "PirInitT", function()
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", PIRATE.name, "Pirate")
		LANG.AddToLanguage("English", "info_popup_" .. PIRATE.name, [[You ARRR a Pirate! Search someone to fight for - earn gold and points.]])
		LANG.AddToLanguage("English", "body_found_" .. PIRATE.abbr, "This was an Pirate...")
		LANG.AddToLanguage("English", "search_role_" .. PIRATE.abbr, "This person was an Pirate!")
		LANG.AddToLanguage("English", "target_" .. PIRATE.name, "Pirate")
		LANG.AddToLanguage("English", "ttt2_desc_" .. PIRATE.name, [[The Pirate is a neutral role. He doesn’t really care about what’s good and what’s evil… 
		all that matters is, that there’s money involved. As long as another person owns the Pirate Captain’s contract, all pirates are on the same team as them.]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", PIRATE.name, "Pirat")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. PIRATE.name, [[Du bist ein Pirat! Tu dich mit jemandem zusammen und kämpfe für Gold und Punkte.]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. PIRATE.abbr, "Er war ein Pirat...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. PIRATE.abbr, "Diese Person war ein Pirat!")
		LANG.AddToLanguage("Deutsch", "target_" .. PIRATE.name, "Pirat")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. PIRATE.name, [[Piraten sind neutral. Sie kümmern sich nicht um gut und böse... das Geld muss stimmen.
		So lange eine andere Person einen Vertrag mit dem Piraten geschlossen hat, kämpft er für sein Team.]])
	end)
else
	--cleanup
	hook.Add("TTTPrepareRound", "TTT2PirPrepRound", function()
		for _, ply in ipairs(player.GetAll()) do
			ply.is_pir_master = nil
			ply.pirate_master = nil
			ply.pir_contract = nil
		end
	end)

	--pirates and master should always see their roles 
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RolePirVis", function(ply, tbl)
		if ply and not ply.is_pir_master and ply:GetBaseRole() ~= ROLE_PIRATE or GetRoundState() == ROUND_POST then return end

		for pir in pairs(tbl) do
			if pir:GetBaseRole() == ROLE_PIRATE or pir.is_pir_master then
				tbl[pir] = {pir:GetSubRole(), pir:GetTeam()}
			end
		end
	end)
end	