function()
    local bossesString = aura_env.createStringForBoses()
    local questsString = aura_env.createStringForQuests()
    local raidsString = aura_env.createStringForRaids()
    
    return  bossesString .. questsString .. raidsString
end