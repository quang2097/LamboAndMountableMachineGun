require('NPCs/MainCreationMethods');

local function RFNGP_Trait()
    local sleepOK = (isClient() or isServer()) and getServerOptions():getBoolean("SleepAllowed") and getServerOptions():getBoolean("SleepNeeded")
    local gunenthusiastRFNGP = TraitFactory.addTrait("gunenthusiastRFNGP", getText("UI_trait_gunenthusiastRFNGP"), 6, getText("UI_trait_gunenthusiastRFNGPdesc"), false, false);
    gunenthusiastRFNGP:addXPBoost(Perks.Aiming, 1);
    gunenthusiastRFNGP:addXPBoost(Perks.Reloading, 1);
    gunenthusiastRFNGP:addXPBoost(Perks.Nimble, 1);
    end

Events.OnGameBoot.Add(RFNGP_Trait);