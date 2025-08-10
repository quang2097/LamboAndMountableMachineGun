-- local originalPageCanPutIn = ISInventoryPage.canPutIn

-- function ISInventoryPage:canPutIn()
--     local container = self.mouseOverButton and self.mouseOverButton.inventory or nil
--     if not container then
--         return false
--     end
--     if container:getType() == "Basket" or container:getType() == "Saddlebag" or container:getType() == "Crate" then
--         return true
--     end
--     return originalPageCanPutIn(self)
-- end

-- local originalPaneCanPutIn = ISInventoryPane.canPutIn

-- function ISInventoryPane:canPutIn()
--     local container = self.inventory
--     if not container then
--         return false
--     end
--     if container:getType() == "Basket" or container:getType() == "Saddlebag" or container:getType() == "Crate" then
--         return true
--     end
--     return originalPaneCanPutIn(self)
-- end

local options = PZAPI.ModOptions:getOptions("BicycleMod")
local originalRenderDetails = ISInventoryPane.renderdetails

function ISInventoryPane:renderdetails(doDragged)
    local bicycleBetterInvFix = options:getOption("BicycleBetterInvFix"):getValue()
    if bicycleBetterInvFix then
        return originalRenderDetails(self, doDragged)
    end

    self:updateScrollbars();

    if doDragged == false then
        table.wipe(self.items)

        if self.inventory:isDrawDirty() then
            self:refreshContainer()
        end
    end

    local player = getSpecificPlayer(self.player)

    local checkDraggedItems = false
    if doDragged and self.dragging ~= nil and self.dragStarted then
        self.draggedItems:update()
        checkDraggedItems = true
    end

    if not doDragged then
        self:drawRectStatic(0, 0, self.column2, self.height, 0.6, 0, 0, 0);
    end
    local y = 0;
    local alt = false;
    if self.itemslist == nil then
        self:refreshContainer();
    end
    local MOUSEX = self:getMouseX()
    local MOUSEY = self:getMouseY()
    local YSCROLL = self:getYScroll()
    local HEIGHT = self:getHeight()
    local equippedLine = false
    local all3D = true;
    for k, v in ipairs(self.itemslist) do
        local count = 1;
        for k2, v2 in ipairs(v.items) do
            local item = v2;
            if item:getType() == ContainerMap[item:getType()] then
                if not item:isInPlayerInventory() or item:isEquipped() then
                    break;
                end
            end
            local doIt = true;
            local xoff = 0;
            local yoff = 0;
            if doDragged == false then
                if count == 1 then
                    table.insert(self.items, v);
                else
                    table.insert(self.items, item);
                end

                if instanceof(item, 'InventoryItem') then
                    item:updateAge()
                end
                if instanceof(item, 'Clothing') then
                    item:updateWetness()
                end
            end
            local isDragging = false
            if self.dragging ~= nil and self.selected[y+1] ~= nil and self.dragStarted then
                xoff = MOUSEX - self.draggingX;
                yoff = MOUSEY - self.draggingY;
                if not doDragged then
                    doIt = false;
                else
                    self:suspendStencil();
                    isDragging = true
                end
            else
                if doDragged then
                    doIt = false;
                end
            end
            local topOfItem = y * self.itemHgt + YSCROLL
            if not isDragging and ((topOfItem + self.itemHgt < 0) or (topOfItem > HEIGHT)) then
                doIt = false
            end
            if doIt == true then
                if self.joyselection ~= nil and self.doController then
                    if self.joyselection == y then
                        self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self:getWidth()-1, self.itemHgt, 0.2, 0.2, 1.0, 1.0);
                    end
                end
                local tex = item:getTex();
                if tex ~= nil then
					local texDY = 0
					local texWH = math.min(self.itemHgt-2,32)
					local auxDXY = self.itemHgt-(self.itemHgt-texWH)/2-13
                    local texOffsetY = (y*self.itemHgt)+(self.itemHgt-texWH)/2+self.headerHgt+yoff
                    local texOffsetX = self.column2-texWH-(self.itemHgt-texWH)/2+xoff
                    if count == 1  then
                        ISInventoryItem.renderItemIcon(self, item, texOffsetX, texOffsetY+texDY, 1.0, texWH, texWH);
						if player:isEquipped(item) then
							self:drawTexture(self.equippedItemIcon, texOffsetX+auxDXY, texOffsetY+auxDXY, 1, 1, 1, 1);
						end
						if not self.hotbar then
							self.hotbar = getPlayerHotbar(self.player);
						end
						if not player:isEquipped(item) and self.hotbar and self.hotbar:isInHotbar(item) then
							self:drawTexture(self.equippedInHotbar, texOffsetX+auxDXY, texOffsetY+auxDXY, 1, 1, 1, 1);
						end
                        if item:isBroken() then
                            self:drawTexture(self.brokenItemIcon, texOffsetX+auxDXY, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                        if instanceof(item, "Food") and item:isFrozen() then
                            self:drawTexture(self.frozenItemIcon, texOffsetX+auxDXY, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                        if instanceof(item, "Food") and(item:isTainted() and getSandboxOptions():getOptionByName("EnableTaintedWaterText"):getValue()) or player:isKnownPoison(item) or item:hasTag("ShowPoison") then
                            self:drawTexture(self.poisonIcon, texOffsetX+auxDXY, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                        if self and self.isLiteratureRead and player and item then
                            local success, isRead = pcall(function()
                                return self:isLiteratureRead(player, item)
                            end)
                            if success and isRead then
                                self:drawTexture(getTexture("media/ui/Tick_Mark-10.png"), texOffsetX+auxDXY, texOffsetY+auxDXY-1, 1, 1, 1, 1)
                            end
                        end
                        local fluidContainer = item:getFluidContainer() or (item:getWorldItem() and item:getWorldItem():getFluidContainer());
						if fluidContainer ~= nil and getSandboxOptions():getOptionByName("EnableTaintedWaterText"):getValue() and (not fluidContainer:isEmpty()) and (fluidContainer:contains(Fluid.Bleach) or (fluidContainer:contains(Fluid.TaintedWater) and fluidContainer:getPoisonRatio() > 0.1)) then
							self:drawTexture(self.poisonIcon, (10+auxDXY+xoff), (y*self.itemHgt)+self.headerHgt+auxDXY-1+yoff, 1, 1, 1, 1);
						end
                        if item:isFavorite() then
                            self:drawTexture(self.favoriteStar, texOffsetX, texOffsetY+auxDXY, 1, 1, 1, 1);
                        end
                    elseif v.count > 2 or (doDragged and count > 1 and self.selected[(y+1) - (count-1)] == nil) then
                        ISInventoryItem.renderItemIcon(self, item, 10+16+xoff, texOffsetY+texDY, 1.0, texWH, texWH);
						if player:isEquipped(item) then
							self:drawTexture(self.equippedItemIcon, texOffsetX+auxDXY+16, texOffsetY+auxDXY, 1, 1, 1, 1);
                        end
                        if item:isBroken() then
                            self:drawTexture(self.brokenItemIcon, texOffsetX+auxDXY+16, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                        if instanceof(item, "Food") and item:isFrozen() then
                            self:drawTexture(self.frozenItemIcon, texOffsetX+auxDXY+16, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                        if item:isFavorite() then
                            self:drawTexture(self.favoriteStar, texOffsetX+auxDXY+19, texOffsetY+auxDXY-1, 1, 1, 1, 1);
                        end
                    end
                end
                if count == 1 and v.count > 2 then
					if not doDragged then
                        local texWH = math.min(self.itemHgt-2,32)
                        local texOffsetX = self.column2-texWH-(self.itemHgt-texWH)/2+xoff
                        local size = math.min(15, 8+getCore():getOptionFontSizeReal()*2)
                        local xPos = math.max(2, (2+texOffsetX-size)/2)
                        if not self.collapsed[v.name] then
                            self:drawTextureScaled(self.treeexpicon, xPos, (y*self.itemHgt)+self.headerHgt+(self.itemHgt-15)/2+yoff, size, size, 1, 1, 1, 0.8)
                        else
                            self:drawTextureScaled(self.treecolicon, xPos, (y*self.itemHgt)+self.headerHgt+(self.itemHgt-15)/2+yoff, size, size, 1, 1, 1, 0.8)
                        end
                    end
                end

                if self.selected[y+1] ~= nil and not self.highlightItem then
					if checkDraggedItems and self.draggedItems:cannotDropItem(item) then
						self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self:getWidth()-1, self.itemHgt, 0.20, 1.0, 0.0, 0.0);
					elseif false and (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
						if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
							self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.5, math.abs(item:getInvHeat()), 0.0, 0.0);
						else
							self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.5, 0.0, 0.0, math.abs(item:getInvHeat()));
						end
                    else
						self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self:getWidth()-1, self.itemHgt, 0.20, 1.0, 1.0, 1.0);
					end
                elseif self.mouseOverOption == y+1 and not self.highlightItem then
					if(((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                        if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
							self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.3, math.abs(item:getInvHeat()), 0.0, 0.0);
						else
							self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.3, 0.0, 0.0, math.abs(item:getInvHeat()));
						end
                    else
						self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self:getWidth()-1, self.itemHgt, 0.05, 1.0, 1.0, 1.0);
					end
                else
                    if count == 1 then
                        if self.highlightItem and self.highlightItem == item:getType() then
                            if not self.blinkAlpha then self.blinkAlpha = 0.5; end
                            self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  self.blinkAlpha, 1, 1, 1);
                            if not self.blinkAlphaIncrease then
                                self.blinkAlpha = self.blinkAlpha - 0.05 * (UIManager.getMillisSinceLastRender() / 33.3);
                                if self.blinkAlpha < 0 then
                                    self.blinkAlpha = 0;
                                    self.blinkAlphaIncrease = true;
                                end
                            else
                                self.blinkAlpha = self.blinkAlpha + 0.05 * (UIManager.getMillisSinceLastRender() / 33.3);
                                if self.blinkAlpha > 0.5 then
                                    self.blinkAlpha = 0.5;
                                    self.blinkAlphaIncrease = false;
                                end
                            end
                        else
                            if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                                if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
                                    if alt then
                                        self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.15, math.abs(item:getInvHeat()), 0.0, 0.0);
                                    else
                                        self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.2, math.abs(item:getInvHeat()), 0.0, 0.0);
                                    end
                                else
                                    if alt then
                                        self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.15, 0.0, 0.0, math.abs(item:getInvHeat()));
                                    else
                                        self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.2, 0.0, 0.0, math.abs(item:getInvHeat()));
                                    end
                                end
                            else
                                if alt then
                                    self:drawRect(self.column2+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt, 0.02, 1.0, 1.0, 1.0);
                                else
                                    self:drawRect(self.column2+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt, 0.2, 0.0, 0.0, 0.0);
                                end
                            end
                        end
                    else
                        if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() ~= 1) or item:getItemHeat() ~= 1) then
                            if (((instanceof(item,"Food") or instanceof(item,"DrainableComboItem")) and item:getHeat() > 1) or item:getItemHeat() > 1) then
								self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.2, math.abs(item:getInvHeat()), 0.0, 0.0);
							else
								self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.2, 0.0, 0.0, math.abs(item:getInvHeat()));
							end
						else
							self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, self.column4, self.itemHgt,  0.4, 0.0, 0.0, 0.0);
						end
                    end
                end
                if v.equipped then
                    if not doDragged and not equippedLine and y > 0 then
                        self:drawRect(1, ((y+1)*self.itemHgt)+self.headerHgt-1-self.itemHgt, self.column4, 1, 0.2, 1, 1, 1);
                    end
                    equippedLine = true
                end

                if item:getJobDelta() > 0 and (count > 1 or self.collapsed[v.name]) then
                    local scrollBarWid = self:isVScrollBarVisible() and 13 or 0
                    local displayWid = self.column4 - scrollBarWid
                    self:drawRect(1+xoff, (y*self.itemHgt)+self.headerHgt+yoff, displayWid * item:getJobDelta(), self.itemHgt, 0.2, 0.4, 1.0, 0.3);
                end

				local textDY = (self.itemHgt - self.fontHgt) / 2

                local itemName = item:getName();
                if count == 1 then
					if doDragged and ISMouseDrag.dragging and #ISMouseDrag.dragging > 0 then
						local red = false;
						if red then
							if v.count > 2 then
								self:drawText(itemName.." ("..(v.count-1)..")", self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.0, 0.0, 1.0, self.font);
							else
								self:drawText(itemName, self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.0, 0.0, 1.0, self.font);
							end
						else
							if v.count > 2 then
								self:drawText(itemName.." ("..(v.count-1)..")", self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.7, 0.7, 1.0, self.font);
							else
								self:drawText(itemName, self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.7, 0.7, 1.0, self.font);
							end
						end
					else
						local clipX = math.max(0, self.column2+xoff)
						local clipY = math.max(0, (y*self.itemHgt)+self.headerHgt+yoff+self:getYScroll())
						local clipX2 = math.min(clipX + self.column3-self.column2, self.width)
						local clipY2 = math.min(clipY + self.itemHgt, self.height)
						if clipX < clipX2 and clipY < clipY2 then
						self:setStencilRect(clipX, clipY, clipX2 - clipX, clipY2 - clipY)
						if v.count > 2 then
							self:drawText(itemName.." ("..(v.count-1)..")", self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.7, 0.7, 1.0, self.font);
						else
							self:drawText(itemName, self.column2+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.7, 0.7, 1.0, self.font);
						end
						self:clearStencilRect()
						self:repaintStencilRect(clipX, clipY, clipX2 - clipX, clipY2 - clipY)
						end
					end
                end
                if item:getJobDelta() > 0  then
                    if  (count > 1 or self.collapsed[v.name]) then
						if self.dragging == count then
							self:drawText(item:getJobType(), self.column3+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.0, 0.0, 1.0, self.font);
						else
							self:drawText(item:getJobType(), self.column3+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.7, 0.7, 0.7, 1.0, self.font);
						end
                    end

                else
                    if count == 1 then
						if doDragged then
                        elseif item:getDisplayCategory() then
                            self:drawText(getText("IGUI_ItemCat_" .. item:getDisplayCategory()), self.column3+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.6, 0.6, 0.8, 1.0, self.font);
                        else
                            self:drawText(getText("IGUI_ItemCat_" .. item:getCategory()), self.column3+8+xoff, (y*self.itemHgt)+self.headerHgt+textDY+yoff, 0.6, 0.6, 0.8, 1.0, self.font);
                        end
                    else
                        local redDetail = false;
                        self:drawItemDetails(item, y, xoff, yoff, redDetail);
                    end

                end
                if self.selected ~= nil and self.selected[y+1] ~= nil then
                    self:resumeStencil();
                end

            end
            if count == 1 then
                if alt == nil then alt = false; end
                alt = not alt;
            end

            y = y + 1;

            if count == 1 and self.collapsed ~= nil and v.name ~= nil and self.collapsed[v.name] then
                if instanceof(item, "Food") then
                    for k3,v3 in ipairs(v.items) do
                        v3:updateAge()
                    end
                end
                break
            end
            if count == ISInventoryPane.MAX_ITEMS_IN_STACK_TO_RENDER + 1 then
                break
            end
            count = count + 1;
        end
	end

    self:setScrollHeight(y * self.itemHgt);
	self:setScrollWidth(0);

	if self.draggingMarquis then
		local w = self:getMouseX() - self.draggingMarquisX;
		local h = self:getMouseY() - self.draggingMarquisY;
		self:drawRectBorder(self.draggingMarquisX, self.draggingMarquisY, w, h, 0.4, 0.9, 0.9, 1);
    end


    if not doDragged then
		self:drawRectStatic(1, 0, self.width-2, self.headerHgt, 1, 0, 0, 0);
    end

end