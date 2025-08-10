function Suppressor(wielder, weapon)
  if weapon == nil then return end
	if not weapon:IsWeapon() or not weapon:isRanged() then return; end
    local scriptItem = weapon:getScriptItem()
    local scriptItem = weapon:getScriptItem()

    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local swingSound = scriptItem:getSwingSound()

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "9mmSuppressor") then
    	      soundRadius = soundRadius * (0.17) -- This is the part of the code that affects suppressor effectiveness. Make that number smaller if you want your suppressors to be "silencers".
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '9mmSuppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "45Suppressor") then
    	      soundRadius = soundRadius * (0.19)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '9mmSuppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "223556Suppressor") then
    	      soundRadius = soundRadius * (0.15)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '223556Suppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "308762Suppressor") then
    	      soundRadius = soundRadius * (0.15)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '308762Suppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "12gSuppressor") then
    	      soundRadius = soundRadius * (0.25)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '12gSuppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "12gSuppressorImproved") then
    	      soundRadius = soundRadius * (0.13)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = '12gSuppressedImproved'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())

	local canon = weapon:getWeaponPart("Canon")
    if canon then
  		if string.find(canon:getType(), "DIYSuppressor") then
    	      soundRadius = soundRadius * (0.3)
    	      soundVolume = soundVolume *  (1.0)
			  swingSound = 'DIYSuppressed'
				else
          soundRadius = soundRadius * (1)
          soundVolume = soundVolume *  (1)
          swingSound = swingSound
         end
	 end
    weapon:setSoundRadius(soundRadius)
    weapon:setSoundVolume(soundVolume)
    weapon:setSwingSound(swingSound)
    print(scriptItem:getSoundRadius())
end

Events.OnEquipPrimary.Add(Suppressor);

Events.OnGameStart.Add(function()
	local player = getPlayer()
	Suppressor(player, player:getPrimaryHandItem())
end)