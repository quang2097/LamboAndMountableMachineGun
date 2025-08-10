local config = {
    bicycleWalkSpeedMultiplier = nil,
    bicycleRunSpeedMultiplier = nil,
    bicycleImmersiveMode = nil,
    bicycleTransferInv = nil,
    bicycleSoundVolume = nil,
    bicycleEditorFix = nil,
    bicycleBetterInvFix = nil,
    bicycleSpawnButton = nil,
    bicycleSaddlebagSpawnButton = nil,
    bicycleBasketSpawnButton = nil,
    bicycleCrateSpawnButton = nil,
    bicycleEquipButton = nil,
    bicycleFixAutoVaultButton = nil,
}

local function BicycleConfig()
    local options = PZAPI.ModOptions:create("BicycleMod", "Bicycle")

    options:addDescription("Change the volume of Bicycle sounds.")
    config.bicycleSoundVolume = options:addSlider("BicycleSoundVolume", "Bicycle Sound Volume (Default 0.40)", 0.01, 1, 0.01, 0.40, "Set sound volume of bicycle sounds.")

    options:addDescription("Change the speed of the  bicycle. Slow is when you're not holding SHIFT, Fast is when you're holding SHIFT.")
    config.bicycleWalkSpeedMultiplier = options:addSlider("SpeedMultSlow", "Bicycle Speed Slow (Default 1.9)", 0.1, 5, 0.1, 1.9, "Set your player speed when riding the bicycle and not holding SHIFT.")
    config.bicycleRunSpeedMultiplier = options:addSlider("SpeedMultFast", "Bicycle Speed Fast (Default 2.7)", 0.1, 5, 0.1, 2.7, "Set your player speed when riding the bicycle and holding SHIFT.")

    options:addDescription("Gameplay Options")
    config.bicycleEquipButton = options:addKeyBind("BicycleEquipButton", "Change button to equip the bicycle", Keyboard.KEY_E, "Change the keybind to equip the bicycle.")
    config.bicycleImmersiveMode = options:addTickBox("BicycleImmersive", "Immersive Mode", true, "Toggle Immersive mode. When enabled you will be a little bit slower on rough surfaces like gravel/sand.")
    config.bicycleTransferInv = options:addTickBox("BicycleTransferInv", "Allow Transfer to Inventory", false, "Toggle to allow the bicycle to be transferred to player inventory.")

    options:addDescription("Debug Options")
    config.bicycleSpawnButton = options:addButton("BicycleSpawn", "Add Bicycle to Inventory (FOR DEBUG PURPOSES)", "Mod updates can cause bicycles to despawn, use this to get one back.", SpawnBicycle)
    config.bicycleSaddlebagSpawnButton = options:addButton("BicycleSaddlebagSpawn", "Add Saddlebags attachment to Inventory (FOR DEBUG PURPOSES)", "Mod updates can cause bicycles and attachments to despawn, use this to get one back.", SpawnBicycleSaddlebag)
    config.bicycleBasketSpawnButton = options:addButton("BicycleBasketSpawn", "Add Basket attachment to Inventory (FOR DEBUG PURPOSES)", "Mod updates can cause bicycles and attachments to despawn, use this to get one back.", SpawnBicycleBasket)
    config.bicycleCrateSpawnButton = options:addButton("BicycleCrateSpawn", "Add Crate attachment to Inventory (FOR DEBUG PURPOSES)", "Mod updates can cause bicycles and attachments to despawn, use this to get one back.", SpawnBicycleCrate)
    config.bicycleFixAutoVaultButton = options:addButton("BicycleFixAutoVault", "Fix Auto Vault", "If you are unable to vault over fences after using a bicycle, click here to fix it.", FixAutoVault)

    options:addDescription("COMPATIBILITY SETTINGS: If you're having mod conflict issues, check these settings and enable the fixes you need.")
    config.bicycleBetterInvFix = options:addTickBox("BicycleBetterInvFix", "Fix [B42] Another items UI beta", false, "Makes the [B42] Another items UI beta work, however, there will be bicycle containers visible in the UI that can't be interacted with.")

    options:addDescription("!! ATTENTION MODDERS !! Enable this option if you need to use the attachment editor. There will be an error on game load, but ignore it.")
    config.bicycleEditorFix = options:addTickBox("BicycleEditorFix", "Fix Attachment Editor", false, "Fixes the attachment editor so the model stays loaded, and the save/exit works as expected.")
end

BicycleConfig()
