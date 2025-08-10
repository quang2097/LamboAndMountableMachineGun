local function tryAttachPart(weapon, part, player)
	if part:canAttach(player, weapon) then
		weapon:attachWeaponPart(player, part)
	elseif player then
		player:getInventory():AddItem(part)
	end
end

function Recipe.OnCreate.RemingtonM1187Sawnoff(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "RemingtonM1187" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.SawnoffM590T(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "MossbergM590T" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.SawnoffLongRanger(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "VarmintRifle" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.SawOffCoachGunStock(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "DoubleBarrelShotgunSawnoff" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.SawOff1187Stock(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "RemingtonM1187Sawnoff" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.SawOffRemingtonM870Stock(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getType() == "ShotgunSawnoff" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			return
		end
	end
end

function Recipe.OnCreate.UseDrumMag(craftRecipeData, character)
	local items = craftRecipeData:getAllConsumedItems();
	local result = craftRecipeData:getAllCreatedItems():get(0);
	for i=0,items:size()-1 do
		local item = items:get(i)
		if item:getSubCategory() == "Firearm" then
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			local parts = item:getAllWeaponParts()
			for i=1,parts:size() do
				tryAttachPart(result, parts:get(i-1), character)
			end
			if secondHand or firstHand then
	        player:setSecondaryHandItem(result);
	        if not player:getPrimaryHandItem() then
	            player:setPrimaryHandItem(result);
	        end
	    end
			return
		end
    end
end

function UseDrumMagTest(item)
	if  (item:isContainsClip() == false) then	
		return true
	end
	return false
end