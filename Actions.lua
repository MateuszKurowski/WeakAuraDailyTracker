aura_env.bosses = {
    { id = 32098, name = "Galleon" },
    { id = 32099, name = "Sha" },
    { id = 32518, name = "Nalak" },
    { id = 32519, name = "Oondasta" },
    { id = 33117, name = "Celestials" },
    { id = 33118, name = "Ordos" },
}

aura_env.quests = {
    { id = 80447, name = "Raid Quest" },
    { id = 80448, name = "Scenario Quest" },
    { id = 80446, name = "Dungeon Quest" },
    { id = 80442, name = "Sunreaver Rep Daily (isle of thunder key)" },
    { id = 80443, name = "Kirin Tor Offensive Rep Daily (isle of thunder key) " },
}

aura_env.raids = {
    { id = 1008, name = "Mogu'shan Vaults" },
    { id = 996, name = "Terrace of Endless Spring" },
    { id = 1009, name = "Heart of Fear" },
    { id = 1098, name = "Throne of Thunder" },
    { id = 1136, name = "Siege of Orgrimmar" },
}

aura_env.createStringForBoses = function ()
    local output = ""
    local color = ColorToHex(aura_env.config.bossColor)
    local selectedBosses = aura_env.config.selectedBosses
    for index, isSelected in pairs(selectedBosses) do
        if isSelected then
            local boss = aura_env.bosses[index]
            local isFinished = IsQuestCompleted(boss.id)
            local result = CreateString(color, boss.name, nil, isFinished)
            if (result) then
                output = output .. result
            end
        end
    end
    
    return output
end

aura_env.createStringForQuests = function ()
    local output = ""
    local color = ColorToHex(aura_env.config.questColor)
    local selectedQuests = aura_env.config.selectedQuests
    for index, isSelected in pairs(selectedQuests) do
        if isSelected then
            local quest = aura_env.quests[index]
            local isFinished = IsQuestCompleted(quest.id)
            local result = CreateString(color, quest.name, quest.id, isFinished)
            if (result) then
                output = output .. result
            end
        end
    end
    
    return output
end

aura_env.createStringForRaids = function ()
    local output = ""
    local color = ColorToHex(aura_env.config.raidColor)
    local selectedRaids = aura_env.config.selectedRaids
    for index, isSelected in pairs(selectedRaids) do
        if isSelected then
            local raid = aura_env.raids[index]
            local isFinished = IsRaidCompleted(raid.id)
            local result = CreateString(color, raid.name, nil, isFinished)
            if (result) then
                output = output .. result
            end
        end
    end
    
    return output
end

function CreateString(color, name, id, isFinished)
    local completedColor = ColorToHex(aura_env.config.completedColor)
    local completedText = aura_env.config.completedText
    local availableColor = ColorToHex(aura_env.config.availableColor)
    local availableText = aura_env.config.availableText
    local showIfNotPickedUpTasks = aura_env.config.showIfNotPickedUpTasks
    
    local output = color .. name .. "|r" .. "|r - "
    if (isFinished and not aura_env.config.removeCompleted) then
        return output .. completedColor .. completedText .. "|r" .. "\n"
    elseif (isFinished and aura_env.config.removeCompleted) then
        return
    elseif ((not isFinished and id == nil) or (not isFinished and not showIfNotPickedUpTasks and not (id == nil))) then
        output = output .. availableColor .. availableText
    end
    
    if (showIfNotPickedUpTasks and not (id == nil)) then
        local notPickedUpColor = ColorToHex(aura_env.config.notPickedUpColor)
        local notPickedUpText = aura_env.config.notPickedUpText
        local readyForTurnInColor = ColorToHex(aura_env.config.readyForTurnInColor)
        local readyForTurnInText = aura_env.config.readyForTurnInText
        
        local questInLog = C_QuestLog.IsOnQuest(id)
        local readyForTurnin = C_QuestLog.ReadyForTurnIn(id)
        if readyForTurnin then
            output = output .. " " .. readyForTurnInColor .. readyForTurnInText
        else
            if not questInLog then
                output = output .. availableColor .. availableText .. " " .. notPickedUpColor .. notPickedUpText
            else 
                output = output .. availableColor .. availableText
            end
        end
    end
    
    return output .. "|r" .. "\n"
end

function ColorToHex(color)
    return string.format("|cff%02x%02x%02x", color[1] * 255, color[2] * 255, color[3] * 255)
end

function IsQuestCompleted(questId)
    local finished = C_QuestLog.IsQuestFlaggedCompleted(questId)
    return finished
end

function IsRaidCompleted(raidId)
    for i = 1, GetNumSavedInstances() do
        local name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId = GetSavedInstanceInfo(i)
        if raidId == instanceId and (locked or extended) then
            return true
        end
    end
    return false
end

