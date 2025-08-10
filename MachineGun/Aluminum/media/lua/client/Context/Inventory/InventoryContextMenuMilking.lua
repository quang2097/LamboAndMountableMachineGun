require("Waystone")

ISInventoryMenuElements = ISInventoryMenuElements or {}

function ISInventoryMenuElements.ContextMilking()
	local self = ISMenuElement.new();
	self.invMenu = ISContextManager.getInstance().getInventoryMenu();

	function self.init()
	end

	local enduranceUse = 0.5;
	local fatigueIncrease = 0.5;
	local caloriesUsed = 1000;

	function self.createMenu(_item)
		local player = getPlayer();
		local stats = player:getStats();
		local nutrition = player:getNutrition()
		if _item:getFullType() == "Base.BucketEmpty" and player:isFemale() 
			and nutrition:getCalories() - caloriesUsed >= -2200 
			and stats:getEndurance() >= enduranceUse
			and stats:getFatigue() + fatigueIncrease <= 1 then
			local mainMenu = self.invMenu.context:addOption(getText("IGUI_Milking"), player, self.Milk, player:getInventory());
		end
	end

	function self.Milk(player, inventory)
		inventory:AddItem("Base.Milk")
		local stats = player:getStats();
		stats:setEndurance(stats:getEndurance()-enduranceUse)
		stats:setFatigue(stats:getFatigue()+fatigueIncrease)
		local nutrition = player:getNutrition()
		nutrition:setCalories(nutrition:getCalories()-caloriesUsed)
	end

	return self
end
