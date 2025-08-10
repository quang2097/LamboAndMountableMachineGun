require "TimedActions/ISBaseTimedAction"

function ISUnloadBulletsFromMagazine:animEvent(event, parameter)
	if event == 'RemoveBulletSound' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			return
		end
		self.character:playSound(parameter)
	elseif event == 'RemoveBullet' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			return
		end
		if not isClient() then
			local chance = 5;
			local xp = 1;
			if self.character:getPerkLevel(Perks.Reloading) < 5 then
				chance = 2;
				xp = 4;
			end
			if ZombRand(chance) == 0 then
				addXp(self.character, Perks.Reloading, xp)
			end
			local newBullet = instanceItem(self.magazine:getAmmoType())
			self.character:getInventory():AddItem(newBullet)
			self.magazine:setCurrentAmmoCount(self.magazine:getCurrentAmmoCount() - 1)
			sendAddItemToContainer(self.character:getInventory(), newBullet)
			syncItemFields(self.character, self.magazine)
		end
		self.unloadFinished = false
	elseif event == 'unloadFinished' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			self.unloadFinished = true
			if isServer() then
				self.netAction:forceComplete()
			end
		end
	end
end

function ISRemoveWeaponUpgrade:isValid()
	if isClient() and self.weapon then
			return self.character:getInventory():containsID(self.weapon:getID())
	else
		if not self.character:getInventory():contains(self.weapon) then return false end
	end
	return self.weapon:getWeaponPart(self.partType) ~= nil
end

function ISUpgradeWeapon:isValid()
	if self.part:getPartType() == "Clip" then return false end
	if self.weapon:getWeaponPart(self.part:getPartType()) then return false end
	if isClient() and self.part and self.weapon then
		return self.character:getInventory():containsID(self.part:getID()) and self.character:getInventory():containsID(self.weapon:getID());
	else
		return self.character:getInventory():contains(self.part);
	end
end

function ISRemoveWeaponUpgrade:perform()
		self.character:resetEquippedHandsModels();
		ISBaseTimedAction.perform(self);
end

function ISUpgradeWeapon:perform()
		local playerObj = self.character
		local wep = self.weapon
		self.weapon:setJobDelta(0.0);
		self.part:setJobDelta(0.0);
		self.character:resetEquippedHandsModels();
		ISBaseTimedAction.perform(self);
end

function ISInsertMagazine:complete()
	local Magazine = instanceItem(self.gun:getMagazineType() .. "_Attachment")
	if Magazine then
		self.gun:attachWeaponPart(Magazine , true)
	end
	return true
end

function ISEjectMagazine:complete()
	local Magazine = self.gun:getWeaponPart("Clip")
	if Magazine then
		self.gun:detachWeaponPart(self.character, Magazine)
	end
	return true
end

local function ISAttachMagazine(wielder, weapon)
	if weapon == nil then return end
	if not weapon:IsWeapon() or not weapon:isRanged() then return; end

	local magazineType = weapon:getMagazineType()
	if magazineType and weapon:isContainsClip() then
		weapon:attachWeaponPart(instanceItem(magazineType .. "_Attachment"))
	elseif magazineType and not weapon:isContainsClip() then
		weapon:detachWeaponPart(weapon:getWeaponPart("Clip"))
	end
end

Events.OnEquipPrimary.Add(ISAttachMagazine);

