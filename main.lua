local addonName, db = ...
local instanceToMap = {}
local instanceOrderMap = {}
for i, id in ipairs(db.instanceOrderList) do
    instanceOrderMap[id] = i
end
local faction

bountyHelper = {}
BountyHelperDB = {}

bountyHelper.difficultyViewData = {}

local ignoreList = {}
local hideIgnored = false
local hideOwned = false
local hideKilled = false
local hideButton = false
local lockEsc = false
local currentScale = 1.0

bountyHelper.frames = {}
bountyHelper.contentFrames = {}
bountyHelper.secondTabFrames = {}

local function findBossByEncounterID(instanceID, encounterID)
    local bossList = db.bossData[instanceID]
    if not bossList then return nil, nil end

    for i, boss in ipairs(bossList) do
        if boss.encounterID == encounterID then
            return boss, i
        end
    end
    return nil, nil
end

local function sharedDifficulty(difficultyID, instanceID, encounterID)
    local sharedGroups = {
        {3, 4, 5, 6}
    }

    local targetGroup
    for _, group in ipairs(sharedGroups) do
        if tContains(group, difficultyID) then
            targetGroup = group
            break
        end
    end

    if not targetGroup then return end

    local boss, bossIndex = findBossByEncounterID(instanceID, encounterID)
    if not boss then return end

    for _, sharedID in ipairs(targetGroup) do
        if sharedID ~= difficultyID and boss.killedAtDiff[sharedID] ~= nil then
            boss.killedAtDiff[sharedID] = true
            if bountyHelper.difficultyViewData[sharedID] and bountyHelper.difficultyViewData[sharedID][instanceID] then
                 for _, cachedBoss in ipairs(bountyHelper.difficultyViewData[sharedID][instanceID]) do
                    if cachedBoss.encounterID == encounterID then
                        cachedBoss.killed = true
                    end
                end
            end
        end
    end
end

local difficultyInfo = {
    [1] = {name = "Normal Dungeons", expanded = false},
    [2] = { name = "Heroic Dungeons", expanded = false},
    [3] = {name = "Normal (10) Raids", expanded = false},
    [4] = {name = "Normal (25) Raids", expanded = false},
    [5] = {name = "Heroic (10) Raids", expanded = false},
    [6] = {name = "Heroic (25) Raids", expanded = false},
    [14] = {name = "Normal Raids", expanded = false},
    [15] = {name = "Heroic Raids", expanded = false},
    [16] = {name = "Mythic Raids", expanded = false},
    [17] = {name = "LFR Raids", expanded = false},
    [23] = {name = "Mythic Dungeons", expanded = false},
    order = {17, 3, 4, 14, 5, 6, 15, 16, 1, 2, 23}
}

local colors = {
    gold = "|cffffd700", green = "|cff00ff00", red = "|cffff4040",
    grey = "|cffb0b0b0", white = "|cffffffff", BLUE = "|cff70aeff",
    blackRGB = {0.03137, 0.03137, 0.03137},
    blackRGBA = {0.03137, 0.03137, 0.03137, 0.825},
    goldRGB = {1, 0.7529411764705882, 0},
    redRGB = {1, 0.2509803921568627, 0.2509803921568627}
}

dbBH = {minimap = {hide = false}}
local buttonBH
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("BountyHelper",{
  icon = "Interface\\AddOns\\BountyHelper\\Assets\\icon",
  OnClick = function(self,button) if button == "LeftButton" then bountyHelper:Toggle() end end,
  OnTooltipShow = function(tooltip)
    tooltip:AddLine("|cffffffffBounty Helper")
    tooltip:AddLine(colors.green .. "<Left Click to toggle>")
    tooltip:SetScale(GameTooltip:GetScale())
  end
})

local function createRect(parent, size, point, color, texture, name)
    local f = CreateFrame("Frame", name, parent, "BackdropTemplate")
    f:SetSize(unpack(size))
    f:SetPoint(unpack(point))
    f:SetBackdrop({bgFile = texture or "Interface\\Buttons\\WHITE8x8"})
    if color then f:SetBackdropColor(unpack(color)) end

    return f
end

local function createButton(parent, point, texture, color, onClick, size, tooltip)
    local f = CreateFrame("Button", nil, parent)
    f.color = color
    f:SetSize(unpack(size or {32, 32}))
    f:SetPoint(unpack(point))
    f.texture = f:CreateTexture(nil, "OVERLAY")
    f.texture:SetAllPoints()
    f.texture:SetTexture("Interface\\AddOns\\BountyHelper\\Assets\\" .. texture)
    f.texture:SetVertexColor(unpack(color))

    f:SetScript("OnEnter", function()
        f.texture:SetVertexColor(1, 1, 1)
        if tooltip then
            GameTooltip:SetOwner(f, "ANCHOR_LEFT")
            GameTooltip:SetText(tooltip)
            GameTooltip:Show()
        end
    end)
    f:SetScript("OnLeave", function()
        f.texture:SetVertexColor(unpack(f.color))
        if tooltip then GameTooltip_Hide() end
    end)
    f:SetScript("OnClick", onClick)

    function f:setColor(newColor)
        f.color = newColor
        f.texture:SetVertexColor(unpack(newColor))
    end

    return f
end

local function createText(parent, template, point, size, font)
    local f = parent:CreateFontString(nil, "ARTWORK", template)
    if size then f:SetSize(unpack(size)) end
    f:SetPoint(unpack(point))
    if font then f:SetFont(unpack(font)) end
    
    return f
end

local settingsTimer
function bountyHelper:createUI()
    local settingsPanel

    local f = createRect(UIParent, {650, 600}, BountyHelperDB.point, colors.blackRGBA, nil, "bountyHelperFrame")
    f:SetFrameStrata("HIGH")
    f:SetClipsChildren(true)
    f:SetMovable(true)
    f:SetPropagateKeyboardInput(true)
    f:Hide()
    f:SetScript("OnMouseDown", f.StartMoving)
    f:SetScript("OnMouseUp", f.StopMovingOrSizing)
    f:SetScript("OnKeyDown", function(_, key)
        if key == GetBindingKey("TOGGLEGAMEMENU") and not lockEsc then
            f:Hide()
            GameMenuFrame:Show()
        end
    end)
    self.frames.main = f

    --TODO
    local toMountViewButton = CreateFrame("Button", "bountyHelperToMountViewButton", f, "UIPanelButtonTemplate")
    toMountViewButton:SetPoint("TOPRIGHT", -60, -6)
    toMountViewButton:SetText("Sort by Mount")
    toMountViewButton:SetSize(120, 22)
    toMountViewButton:SetScale(1.2)
    toMountViewButton:SetScript("OnClick", function() bountyHelper:ShowMountView() end)
    bountyHelper.frames.ToMountViewButton = toMountViewButton
    local toDifficultyViewButton = CreateFrame("Button", "bountyHelperToDifficultyViewButton", f, "UIPanelButtonTemplate")
    toDifficultyViewButton:SetPoint("TOPRIGHT", -60, -6)
    toDifficultyViewButton:SetText("Sort by Difficulty")
    toDifficultyViewButton:SetSize(120, 22)
    toDifficultyViewButton:SetScale(1.2)
    toDifficultyViewButton:SetScript("OnClick", function() bountyHelper:ShowDifficultyView() end)
    bountyHelper.frames.ToDifficultyViewButton = toDifficultyViewButton
    local diffScrollFrame = CreateFrame("ScrollFrame", "bountyHelperScrollFrame", f, "UIPanelScrollFrameTemplate")
    diffScrollFrame:SetPoint("TOPLEFT", 12, -48)
    diffScrollFrame:SetPoint("BOTTOMRIGHT", -32, 12)
    bountyHelper.frames.ScrollFrame = diffScrollFrame
    local diffScrollChild = CreateFrame("Frame", "bountyHelperScrollChild")
    diffScrollChild:SetSize(f:GetWidth() - 44, 1)
    diffScrollFrame:SetScrollChild(diffScrollChild)
    bountyHelper.frames.ScrollChild = diffScrollChild
    --TODO
    
    local titleText = createText(f, "GameFontNormalHuge", {"TOPLEFT", 12, 0}, {0, 40})
    titleText:SetText(colors.gold .. "Bounty Helper")
    local sortingText = createText(f, "GameFontNormal", {"LEFT", titleText, "RIGHT", 12, 0}, nil, {STANDARD_TEXT_FONT, 16})
    sortingText:SetText(colors.gold .. "Sort By:")
    createButton(f, {"LEFT", sortingText, "RIGHT"}, "expansion", colors.goldRGB, function()
        self:sortContent("default")
    end, nil, "Expansion")
    createButton(f, {"LEFT", sortingText, "RIGHT", 32, 0}, "chance", colors.goldRGB, function()
        self:sortContent("chance")
    end, nil, "Chance")
    createButton(f, {"TOPRIGHT", -36, -4}, "settings", colors.goldRGB, function()
        if settingsTimer then
            settingsTimer:Cancel(); settingsTimer = nil
        end
        settingsPanel:SetShown(not settingsPanel:IsShown())
    end)
    createButton(f, {"TOPRIGHT", -4, -4}, "close", colors.redRGB, function()
        f:Hide()
    end)
    createRect(f, {650, 2}, {"TOP", 0, -40}, colors.goldRGB):SetFrameLevel(10)
    
    local scrollContent = CreateFrame("Frame")
    scrollContent:SetSize(606, 4)
    self.frames.scrollContent = scrollContent
    local scrollFrame = CreateFrame("ScrollFrame", nil, f, "ScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 12, -42)
    scrollFrame:SetPoint("BOTTOMRIGHT", -32, 12)
    scrollFrame:SetScrollChild(scrollContent)
    scrollFrame.ScrollBar:ClearAllPoints()
    scrollFrame.ScrollBar:SetHeight(542)
    scrollFrame.ScrollBar:SetPoint("TOPRIGHT", 20, -8)
    self.frames.scrollFrame = scrollFrame

    settingsPanel = CreateFrame("Frame", nil, f)
    settingsPanel:SetSize(650, 134)
    settingsPanel:SetPoint("BOTTOM")
    settingsPanel:SetFrameLevel(10)
    settingsPanel:SetClipsChildren(true)
    settingsPanel:EnableMouse(true)
    settingsPanel:Hide()
    settingsPanel:SetScript("OnEnter", function()
        if settingsTimer then
            settingsTimer:Cancel(); settingsTimer = nil
        end
    end)
    settingsPanel:SetScript("OnLeave", function()
        settingsTimer = C_Timer.NewTimer(2, function()
            settingsPanel:Hide(); settingsTimer = nil
        end)
    end)
    createRect(settingsPanel, {650, 32}, {"TOP"}, nil, "Interface\\AddOns\\BountyHelper\\Assets\\glow")
    createRect(settingsPanel, {650, 2}, {"TOP", 0, -32}, colors.goldRGB)
    createRect(settingsPanel, {650, settingsPanel:GetHeight() - 34}, {"BOTTOM"}, colors.blackRGB)
    
    local scaleSlider = CreateFrame("Slider", "bountyHelperScaleSlider", settingsPanel, "UISliderTemplate")
    scaleSlider:SetPropagateMouseMotion(true)
    scaleSlider:SetPoint("TOPLEFT", 10, -12-8-2-34)
    scaleSlider:SetWidth(150)
    scaleSlider:SetHeight(22)
    scaleSlider:SetMinMaxValues(0.5, 1.5)
    scaleSlider:SetValueStep(0.05)
    self.frames.ScaleSlider = scaleSlider

    local scaleValueText = scaleSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    scaleValueText:SetFont(STANDARD_TEXT_FONT, 14)
    scaleValueText:SetPoint("LEFT", scaleSlider, "RIGHT", 8, 0)
    self.frames.ScaleValueText = scaleValueText

    scaleSlider:SetScript("OnValueChanged", function(_, value)
        local roundedValue = tonumber(string.format("%.2f", value))
        self.frames.ScaleValueText:SetText(string.format("UI Scale: %.2f", roundedValue))
    end)

    scaleSlider:SetScript("OnMouseUp", function(self)
        local value = self:GetValue()
        local roundedValue = tonumber(string.format("%.2f", value))
        bountyHelper.frames.main:SetScale(roundedValue)
        currentScale = roundedValue
    end)

    local hideButtonCheckbox = CreateFrame("CheckButton", "bountyHelperHideButtonCheckbox", settingsPanel, "UICheckButtonTemplate")
    hideButtonCheckbox:SetPoint("LEFT", scaleSlider, "RIGHT", 117, 0)
    hideButtonCheckbox:SetPropagateMouseMotion(true)
    hideButtonCheckbox.text = hideButtonCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hideButtonCheckbox.text:SetFont(STANDARD_TEXT_FONT, 14)
    hideButtonCheckbox.text:SetPoint("LEFT", hideButtonCheckbox, "RIGHT", 0, 1)
    hideButtonCheckbox.text:SetText("Hide Button")
    hideButtonCheckbox:SetScript("OnClick", function(self)
        hideButton = self:GetChecked()
        buttonBH:SetShown(not hideButton)
        dbBH.minimap.hide = hideButton
    end)
    self.frames.HideButtonCheckbox = hideButtonCheckbox
    
    local hideOwnedCheckbox = CreateFrame("CheckButton", "bountyHelperHideOwnedCheckbox", settingsPanel, "UICheckButtonTemplate")
    hideOwnedCheckbox:SetPropagateMouseMotion(true)
    hideOwnedCheckbox:SetPoint("LEFT", scaleSlider, "RIGHT", 238, 0)
    hideOwnedCheckbox.text = hideOwnedCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hideOwnedCheckbox.text:SetFont(STANDARD_TEXT_FONT, 14)
    hideOwnedCheckbox.text:SetPoint("LEFT", hideOwnedCheckbox, "RIGHT", 0, 1)
    hideOwnedCheckbox.text:SetText("Hide Owned")
    hideOwnedCheckbox:SetScript("OnClick", function(self)
        hideOwned = self:GetChecked()
        bountyHelper:UpdateVisibleFrame()
    end)
    self.frames.HideOwnedCheckbox = hideOwnedCheckbox

    local hideKilledCheckbox = CreateFrame("CheckButton", "bountyHelperHideKilledCheckbox", settingsPanel, "UICheckButtonTemplate")
    hideKilledCheckbox:SetPoint("LEFT", scaleSlider, "RIGHT", 365, 0)
    hideKilledCheckbox:SetPropagateMouseMotion(true)
    hideKilledCheckbox.text = hideKilledCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hideKilledCheckbox.text:SetFont(STANDARD_TEXT_FONT, 14)
    hideKilledCheckbox.text:SetPoint("LEFT", hideKilledCheckbox, "RIGHT", 0, 1)
    hideKilledCheckbox.text:SetText("Hide Killed")
    hideKilledCheckbox:SetScript("OnClick", function(self)
        hideKilled = self:GetChecked()
        bountyHelper:UpdateVisibleFrame()
    end)
    self.frames.HideKilledCheckbox = hideKilledCheckbox

    local lockCheckbox = CreateFrame("CheckButton", "bountyHelperHideKilledCheckbox", settingsPanel, "UICheckButtonTemplate")
    lockCheckbox:SetPoint("TOPLEFT", settingsPanel, 7, -44-8-2-34)
    lockCheckbox:SetPropagateMouseMotion(true)
    lockCheckbox.text = lockCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    lockCheckbox.text:SetFont(STANDARD_TEXT_FONT, 14)
    lockCheckbox.text:SetPoint("LEFT", lockCheckbox, "RIGHT", 0, 1)
    lockCheckbox.text:SetText("Disable Esc to Close")
    lockCheckbox:SetScript("OnClick", function(self)
        lockEsc = self:GetChecked()
    end)
    self.frames.LockCheckbox = lockCheckbox

    local hideIgnoredCheckbox = CreateFrame("CheckButton", "bountyHelperHideIgnoredCheckbox", settingsPanel, "UICheckButtonTemplate")
    hideIgnoredCheckbox:SetPropagateMouseMotion(true)
    hideIgnoredCheckbox:SetPoint("LEFT", lockCheckbox, 184, 0)
    hideIgnoredCheckbox.text = hideIgnoredCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hideIgnoredCheckbox.text:SetFont(STANDARD_TEXT_FONT, 14)
    hideIgnoredCheckbox.text:SetPoint("LEFT", hideIgnoredCheckbox, "RIGHT", 0, 1)
    hideIgnoredCheckbox.text:SetText("Hide Ignored")
    hideIgnoredCheckbox:SetScript("OnClick", function(self)
        hideIgnored = self:GetChecked()
        bountyHelper:UpdateVisibleFrame()
    end)
    self.frames.HideIgnoredCheckbox = hideIgnoredCheckbox
end

function bountyHelper:CreateCategoryHeader(parent, difficultyID)
    local info = difficultyInfo[difficultyID]
    if not info then return nil end

    local header = CreateFrame("Button", nil, parent)
    header:SetSize(parent:GetWidth(), 32)
    header.isCategoryHeader = true
    header.bossRows = {}
    header.difficultyID = difficultyID

    local bg = header:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetColorTexture(0, 0, 0, 0.9)

    local expander = header:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    expander:SetPoint("LEFT", 10, 0)
    header.expander = expander

    local title = header:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    title:SetPoint("LEFT", expander, "RIGHT", 8, 0)
    title:SetText(colors.BLUE .. info.name)
    title:SetJustifyH("LEFT")

    header:SetScript("OnClick", function(self)
        info.expanded = not info.expanded
        bountyHelper:UpdateDiffLayout()
    end)
    
    return header
end

function bountyHelper:CreateBossRow(parent, bossData, header, instanceID)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 20, 52)
    row.bossData = bossData
    row.headerFrame = header
    local data = bossData
    local mapName = instanceToMap[instanceID].name or "Unknown Map"

    local icon = CreateFrame("Button", nil, row)
    icon:SetSize(48, 48)
    icon:SetPoint("LEFT", 5, 0)
    icon:SetNormalTexture(GetItemIcon(data.mountID))
    icon:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetItemByID(data.mountID); GameTooltip:Show() end)
    icon:SetScript("OnLeave", GameTooltip_Hide)
    icon:SetScript("OnClick", function(_, button) if IsControlKeyDown() and not InCombatLockdown() then DressUpMount(data.journalMountID) end end)

    local nameText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    nameText:SetWidth(150)
    nameText:SetWordWrap(false)
    nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 14, -10)
    nameText:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
    nameText:SetText(colors.white .. data.name)
    nameText:SetJustifyH("LEFT")
    nameText:EnableMouse(true)
    nameText:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(data.name)
        GameTooltip:Show()
    end)
    nameText:SetScript("OnLeave", GameTooltip_Hide)
    
    local mapNameText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    mapNameText:SetWidth(150)
    mapNameText:SetWordWrap(false)
    mapNameText:SetPoint("TOPLEFT", nameText, "RIGHT", 8, 0)
    mapNameText:SetFont(STANDARD_TEXT_FONT, 14)
    mapNameText:SetText(colors.BLUE .. mapName)
    mapNameText:SetJustifyH("LEFT")
    mapNameText:EnableMouse(true)
    mapNameText:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        local waypoint = db.waypoints[instanceID]
        GameTooltip:SetText(mapName .. (waypoint and ("\nZone: " .. waypoint.name) or ""))
        GameTooltip:Show()
    end)
    mapNameText:SetScript("OnLeave", GameTooltip_Hide)

    local statusText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    statusText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -3)
    statusText:SetFont(STANDARD_TEXT_FONT, 14)
    statusText:SetJustifyH("LEFT")
    row.statusText = statusText

    local chanceText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    chanceText:SetPoint("RIGHT", -15, 0)
    chanceText:SetFont(STANDARD_TEXT_FONT, 14)
    chanceText:SetJustifyH("RIGHT")
    chanceText:SetFormattedText( "Chance: %s%s|r -> %s%.2f%%|r", colors.grey, (data.chance == 0) and "unknown" or string.format("%.2f%%", data.chance), colors.green, data.chance + 5.0)
    
    return row
end

function bountyHelper:GenerateDifficultyViewData()
    local result = {}
    for mountID, mount in pairs(db.mountData) do
        for _, drop in ipairs(mount.dropsBy) do
            local diff = drop.diff
            local inst = drop.instanceID
            local bossInfo = db.bossData[inst][drop.index]

            if not result[diff] then result[diff] = {} end
            if not result[diff][inst] then result[diff][inst] = {} end

            local isKilled = bossInfo.killedAtDiff[diff]

            local entry = {
                name = bossInfo.name,
                encounterID = bossInfo.encounterID,
                killed = isKilled,
                mountID = mountID,
                journalMountID = mount.journalMountID,
                chance = drop.chance,
                lfr = drop.lfr,
            }
            table.insert(result[diff][inst], entry)
        end
    end
    self.difficultyViewData = result
end

function bountyHelper:PopulateList()
    local scrollChild = bountyHelper.frames.ScrollChild
    
    for _, frame in ipairs(bountyHelper.secondTabFrames) do
        frame:Hide()
    end
    wipe(bountyHelper.secondTabFrames)

    local dataForView = self.difficultyViewData

    for _, difficultyID in ipairs(difficultyInfo.order) do
        local diffData = dataForView[difficultyID]
        local info = difficultyInfo[difficultyID]

        if diffData and info then
            local header = bountyHelper:CreateCategoryHeader(scrollChild, difficultyID)
            table.insert(bountyHelper.secondTabFrames, header)

            local sortedInstanceIDs = {}
            for instanceID in pairs(diffData) do
                table.insert(sortedInstanceIDs, instanceID)
            end

            table.sort(sortedInstanceIDs, function(a, b)
                local orderA = instanceOrderMap[a] or 9999
                local orderB = instanceOrderMap[b] or 9999
                return orderA < orderB
            end)

            for _, instanceID in ipairs(sortedInstanceIDs) do
                local bossList = diffData[instanceID]
                for _, bossEntryData in ipairs(bossList) do
                    local row = bountyHelper:CreateBossRow(scrollChild, bossEntryData, header, instanceID)
                    table.insert(header.bossRows, row)
                    table.insert(bountyHelper.secondTabFrames, row)
                end
            end
        end
    end
end

function bountyHelper:UpdateDiffLayout()
    local scrollChild = bountyHelper.frames.ScrollChild
    local lastVisibleFrame = nil
    local totalHeight = 0
    local yPadding = 4
    local xIndent = 20

    for _, frame in ipairs(bountyHelper.secondTabFrames) do
        local isVisible = true
        if frame.isCategoryHeader then
            local info = difficultyInfo[frame.difficultyID]
            frame.expander:SetText(info.expanded and "-" or "+")
            frame.childCount = 0
        else
            local data = frame.bossData 
            local header = frame.headerFrame
            local categoryInfo = difficultyInfo[header.difficultyID]
            if not categoryInfo.expanded then isVisible = false end
            
            local isOwned = data.journalMountID and C_MountJournal.GetMountInfoByID(data.journalMountID) and select(11, C_MountJournal.GetMountInfoByID(data.journalMountID))

            if isVisible and hideOwned and isOwned then
                isVisible = false;
            end
            if isVisible and hideKilled and data.killed and not isOwned then
                isVisible = false;
            end

            if not ((hideKilled and data.killed and not isOwned) or (hideOwned and isOwned)) then
                 header.childCount = header.childCount + 1
            end

            if isOwned then
                frame.statusText:SetText(colors.gold .. "Owned")
            else
                frame.statusText:SetText(data.killed and (colors.green .. "Killed") or (colors.red .. "Not Killed"))
            end
        end
        frame:SetShown(isVisible)
    end

    for _, frame in ipairs(bountyHelper.secondTabFrames) do
        if frame.isCategoryHeader and frame.childCount == 0 then frame:Hide() end
        if frame:IsShown() then
            frame:ClearAllPoints()
            if not lastVisibleFrame then
                frame:SetPoint("TOP", scrollChild, "TOP", 0, 0)
            else
                frame:SetPoint("TOP", lastVisibleFrame, "BOTTOM", 0, -yPadding)
            end

            if frame.isCategoryHeader then
                frame:SetPoint("LEFT", scrollChild, "LEFT", 0, 0)
            else
                frame:SetPoint("LEFT", scrollChild, "LEFT", xIndent, 0)
            end
            
            lastVisibleFrame = frame
            totalHeight = totalHeight + frame:GetHeight() + yPadding
        end
    end

    scrollChild:SetHeight(math.max(1, totalHeight - yPadding + 10))
end

function bountyHelper:GetUnsortedMountCentricData()
    local mountCentricData = {}
    for mountID, mount in pairs(db.mountData) do
        mountCentricData[mountID] = { sources = {}, journalMountID = mount.journalMountID }
        for _, drop in ipairs(mount.dropsBy) do
            local bossInfo = db.bossData[drop.instanceID][drop.index]
            local isKilled = bossInfo.killedAtDiff[drop.diff]

            local combinedData = {
                name = bossInfo.name,
                encounterID = bossInfo.encounterID,
                killed = isKilled,
                mountID = mountID,
                journalMountID = mount.journalMountID,
                chance = drop.chance,
                lfr = drop.lfr
            }

            table.insert(mountCentricData[mountID].sources, {
                difficultyID = drop.diff,
                instanceID = drop.instanceID,
                bossIndex = drop.index,
                originalData = combinedData
            })
        end
    end

    local orderMap = {}
    for i, id in ipairs(difficultyInfo.order) do
        orderMap[id] = i
    end

    for mountID, data in pairs(mountCentricData) do
        table.sort(data.sources, function(a, b)
            return (orderMap[a.difficultyID] or 999) < (orderMap[b.difficultyID] or 999)
        end)
    end
    
    return mountCentricData
end

function bountyHelper:loadMountData(callback)
    local pending = 45

    for mountID, data in pairs(db.mountData) do
        local item = Item:CreateFromItemID(mountID)
        item:ContinueOnItemLoad(function()
            data.name = item:GetItemName()
            pending = pending - 1
            if pending == 0 then callback() end
        end)
    end
end

--local mountCentricData = self:GetUnsortedMountCentricData()
--DevTools_Dump(mountCentricData[186638])

function bountyHelper:createContent()
    for mountID, data in pairs(db.mountData) do
        local headerRow = self:createHeaderRow(mountID, data.journalMountID, db.mountData[mountID].name, data.dropsBy[1].chance)
        
        local children = {
            [headerRow.ignore] = 1,
            [headerRow.arrow] = 1
        }
        local instanceID = data.dropsBy[1].instanceID
        local mountLink = select(2, GetItemInfo(mountID))

        headerRow.border:SetScript("OnEnter", function(self)
            self:SetAlpha(1)
            headerRow.arrow:Show()
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText(colors.green .. "<Left Click to add Map Pin>")
            GameTooltip:Show()
        end)
        headerRow.border:SetScript("OnLeave", function(self)
            if not children[GetMouseFoci()[1]] then
                self:SetAlpha(0)
                headerRow.arrow:Hide()
            end
            GameTooltip_Hide()
        end)
        headerRow.arrow:HookScript("OnLeave", function(self)
            headerRow.border:SetAlpha(0)
            self:Hide()
        end)
        headerRow.border:SetScript("OnMouseDown", function()
            if IsControlKeyDown() then
                if not InCombatLockdown() then DressUpMount(data.journalMountID) end
            elseif db.waypoints[instanceID] then
                if not InCombatLockdown() then
                    local waypoint = UiMapPoint.CreateFromCoordinates(unpack(db.waypoints[instanceID].point))
                    C_Map.SetUserWaypoint(waypoint)
                    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                    OpenWorldMap(db.waypoints[instanceID].point[4] or db.waypoints[instanceID].point[1])
                    print(string.format("%sBounty Helper:|r Waypoint set for %s", colors.gold, mountLink))
                end
            else
                print(string.format("%sBounty Helper:|r No waypoint data available for %s", colors.gold, mountLink))
            end
        end)
        table.insert(self.contentFrames, headerRow)
        
        for _, source in ipairs(data.dropsBy) do
            local sourceRow = self:createSourceRow(source)
            table.insert(headerRow.sourceRows, sourceRow)
            table.insert(self.contentFrames, sourceRow)
        end
    end
end

function bountyHelper:createHeaderRow(mountID, journalMountID, name, chance)
    local row = CreateFrame("Frame", nil, self.frames.scrollContent)
    row:SetSize(606, 56)
    row:SetClipsChildren(true)
    row.isHeader = true
    row.sourceRows = {}
    row.mountID = mountID
    
    local color = ignoreList[mountID] and colors.redRGB or colors.goldRGB

    local panel = createRect(row, {602, 36}, {"TOP", 0, -2}, colors.blackRGB)
    panel:SetFrameLevel(3)
    local border = createRect(row, {606, 40}, {"TOP"}, color)
    border:SetFrameLevel(2)
    border:SetAlpha(0)
    row.border = border

    local icon = CreateFrame("Button", nil, panel)
    icon:SetSize(36, 36)
    icon:SetPoint("TOPLEFT")
    icon:SetNormalTexture(GetItemIcon(mountID))
    icon:GetNormalTexture():SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
    icon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetItemByID(mountID)
        GameTooltip:Show()
    end)
    icon:SetScript("OnLeave", GameTooltip_Hide)
    icon:SetScript("OnClick", function()
        if IsControlKeyDown() and not InCombatLockdown() then
            DressUpMount(journalMountID)
        end
    end)
    createText(panel, "GameFontNormalLarge", {"TOPLEFT", 48, -10}):SetText(name)
    local chanceText = createText(panel, "GameFontNormal", {"TOPRIGHT", -12, -10}, nil, {STANDARD_TEXT_FONT, 14})
    chanceText:SetJustifyH("RIGHT")
    chanceText:SetFormattedText("Chance: %s%s|r > %s%.1f%%|r", colors.grey, (chance == 0) and "Unknown" or string.format("%.1f%%", chance), colors.green, chance + 5)
    
    local ignore = createButton(panel, {"TOPLEFT", 2, -38}, "ignore", colors.redRGB, function()
        ignoreList[mountID] = not ignoreList[mountID]
        local newColor = ignoreList[mountID] and colors.redRGB or colors.goldRGB
        border:SetBackdropColor(unpack(newColor))
        row.arrow:setColor(newColor)
        self:updateContent()
    end, nil, "Ignore")
    ignore:Hide()
    row.ignore = ignore

    row.expanded = false
    row.arrow = createButton(row, {"BOTTOM"}, "arrow", color, function()
        row.expanded = not row.expanded
        local height = row.expanded and 92 or 56

        row:SetHeight(height)
        panel:SetHeight(height - 20)
        border:SetHeight(height - 16)
        row.arrow.texture:SetTexCoord(unpack(row.expanded and {1, 0, 1, 0} or {0, 1, 0, 1}))
        ignore:SetShown(row.expanded)
    end)
    row.arrow:Hide()

    return row
end

function bountyHelper:createSourceRow(source)
    local row = CreateFrame("Frame", nil, self.frames.scrollContent)
    row:SetSize(606, 30)
    row.source = source

    local nameText = createText(row, "GameFontNormal", {"LEFT", 12, 0}, nil, {STANDARD_TEXT_FONT, 16})
    nameText:SetWordWrap(false)
    nameText:SetText(colors.white .. db.bossData[source.instanceID][source.index].name)
    nameText:SetSize(math.min(nameText:GetWidth(), 180), 30)
    nameText:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(db.bossData[source.instanceID][source.index].name)
        GameTooltip:Show()
    end)
    nameText:SetScript("OnLeave", GameTooltip_Hide)
    --
    local mapNameText = createText(row, "GameFontNormal", {"LEFT", nameText, "RIGHT", 6, 0}, nil, {STANDARD_TEXT_FONT, 14})
    mapNameText:SetWordWrap(false)
    mapNameText:SetText(colors.BLUE .. instanceToMap[source.instanceID].name)
    mapNameText:SetSize(math.min(mapNameText:GetWidth(), 180), 30)
    mapNameText:SetScript("OnEnter", function(self)
        local waypoint = db.waypoints[source.instanceID]
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(instanceToMap[source.instanceID].name .. (waypoint and ("\nZone: " .. waypoint.name) or ""))
        GameTooltip:Show()
    end)
    mapNameText:SetScript("OnLeave", GameTooltip_Hide)
    --
    local diffText = createText(row, "GameFontNormal", {"LEFT", mapNameText, "RIGHT", 6, 0}, nil, {STANDARD_TEXT_FONT, 14})
    diffText:SetText(colors.grey .. difficultyInfo[source.diff].name)
    --
    local statusText = createText(row, "GameFontNormal", {"RIGHT", -12, 0}, nil, {STANDARD_TEXT_FONT, 14})
    statusText:SetJustifyH("RIGHT")
    row.statusText = statusText

    if source.lfr then
        if type(source.lfr[1]) == "table" then
            source.lfr = source.lfr[faction]
        end
        if type(source.wing) == "table" then
            source.wing = source.wing[faction]
        end
        createButton(row, {"LEFT", diffText, "RIGHT"}, "pin", colors.goldRGB, function()
            if not InCombatLockdown() then
                C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(unpack(source.lfr)))
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                OpenWorldMap(source.lfr[4] or source.lfr[1])
                print(string.format("%sBounty Helper:|r Waypoint set", colors.gold))
            end
        end, nil, colors.green .. "<Left Click to add Map Pin>|r\nWing: " .. GetLFGDungeonInfo(source.wing))
    end
    
    return row
end

local lastSorting
local sortingWay = false --Ascending
function bountyHelper:sortContent(sorting)
    if lastSorting == sorting then sortingWay = not sortingWay
    else
        lastSorting = sorting
        sortingWay = false
    end
    
    local defaultOrder = {
        13335, 30480, 32458, 32768, 35513, 43952, 43953, 43959,
        44151, 45693, 49636, 50818, 63040, 63041, 63043, 68823,
        68824, 69224, 71665, 77067, 77069, 78919, 87777, 93666,
        95059, 104253, 116660, 123890, 137574, 137575, 142236,
        143643, 152789, 152816, 159842, 159921, 160829, 166518,
        166705, 174872, 181819, 186638, 186656, 186642, 190768
    }
    local orderMap = {}
    for i, id in ipairs(defaultOrder) do orderMap[id] = i end

    local currentGroup
    local groupedFrames = {}
    for _, frame in ipairs(self.contentFrames) do
        if frame.isHeader then
            currentGroup = {frame}
            table.insert(groupedFrames, currentGroup)
        else table.insert(currentGroup, frame) end
    end

    table.sort(groupedFrames, function(a, b)
        if sortingWay then local c = a; a = b; b = c end
        if sorting == "default" then
            return orderMap[a[1].mountID] < orderMap[b[1].mountID]
        elseif sorting == "chance" then
            local chanceA = a[2].source.chance
            local chanceB = b[2].source.chance

            if chanceA == chanceB then return orderMap[a[1].mountID] < orderMap[b[1].mountID]
            else return chanceA < chanceB end
        end
    end)

    self.contentFrames = {}
    for _, group in ipairs(groupedFrames) do
        for _, element in ipairs(group) do
            table.insert(self.contentFrames, element)
        end
    end

    self:updateContent()
end


function bountyHelper:updateContent()
    for _, frame in ipairs(self.contentFrames) do
        if frame.isHeader then
            local isOwned = select(11, C_MountJournal.GetMountInfoByID(db.mountData[frame.mountID].journalMountID))
            local sourceCount = 0

            for _, sourceRow in ipairs(frame.sourceRows) do
                local source = sourceRow.source
                local boss = db.bossData[source.instanceID][source.index]
                local killed = boss.killedAtDiff[source.diff]

                if isOwned then
                    sourceRow.statusText:SetText(colors.gold .. "Owned")
                else
                    sourceRow.statusText:SetText(killed and (colors.green .. "Killed") or (colors.red .. "Not Killed"))
                end

                local hide = (hideIgnored and ignoreList[frame.mountID]) or (hideOwned and isOwned) or (hideKilled and killed and not isOwned)
                if not hide then sourceCount = sourceCount + 1 end
                sourceRow:SetShown(not hide)
            end
            
            frame:SetShown(sourceCount ~= 0)
        end
    end
    
    local lastFrame = nil
    for _, frame in ipairs(self.contentFrames) do
        if frame:IsShown() then
            frame:ClearAllPoints()
            if not lastFrame then frame:SetPoint("TOP", self.frames.scrollContent, "BOTTOM")
            else frame:SetPoint("TOP", lastFrame, "BOTTOM", 0, lastFrame.isHeader and 12 or -4) end
            lastFrame = frame
        end
    end
end

function bountyHelper:initialize()
    self:createUI()
    self:loadMountData(function()
        self:createContent()
        self:sortContent("default")
    end)

    self:GenerateDifficultyViewData() 
    self:PopulateList()
end

function bountyHelper:ShowDifficultyView()
    bountyHelper.frames.ScrollFrame:Show()
    bountyHelper.frames.ToMountViewButton:Show()
    
    bountyHelper.frames.scrollFrame:Hide()
    bountyHelper.frames.ToDifficultyViewButton:Hide()
    
    bountyHelper:UpdateDiffLayout()
    bountyHelper.frames.main:Show()
end

function bountyHelper:ShowMountView()
    bountyHelper.frames.ScrollFrame:Hide()
    bountyHelper.frames.ToMountViewButton:Hide()

    bountyHelper.frames.scrollFrame:Show()
    bountyHelper.frames.ToDifficultyViewButton:Show()
    
    bountyHelper:updateContent()
    bountyHelper.frames.main:Show()
end

function bountyHelper:Toggle()
    if bountyHelper.frames.main:IsShown() then
        bountyHelper.frames.main:Hide()
    else
        bountyHelper:UpdateDiffLayout()
        bountyHelper:updateContent()
        
        bountyHelper.frames.HideIgnoredCheckbox:SetChecked(hideIgnored)
        bountyHelper.frames.HideOwnedCheckbox:SetChecked(hideOwned)
        bountyHelper.frames.HideKilledCheckbox:SetChecked(hideKilled)
        bountyHelper.frames.HideButtonCheckbox:SetChecked(hideButton)
        bountyHelper.frames.LockCheckbox:SetChecked(lockEsc)
        bountyHelper:ShowMountView()
    end
end

function bountyHelper:UpdateVisibleFrame()
    if bountyHelper.frames.ScrollFrame:IsShown() then
        bountyHelper:UpdateDiffLayout()
    elseif bountyHelper.frames.scrollFrame:IsShown() then
        bountyHelper:updateContent()
    end
end

function checkSaved()
    for i = 1, GetNumSavedInstances() do
        local _, _, reset, difficultyID, _, _, _, _, _, _, numEncounters, _, _, instanceID = GetSavedInstanceInfo(i)
        if reset ~= 0 then
            local bossList = db.bossData[instanceID]
            if bossList then
                for _, boss in ipairs(bossList) do
                    if boss.killedAtDiff[difficultyID] ~= nil then
                        if C_RaidLocks.IsEncounterComplete(instanceID, boss.encounterID, difficultyID) then
                            boss.killedAtDiff[difficultyID] = true
                            if bountyHelper.difficultyViewData[difficultyID] and bountyHelper.difficultyViewData[difficultyID][instanceID] then
                                for _, cachedBoss in ipairs(bountyHelper.difficultyViewData[difficultyID][instanceID]) do
                                    if cachedBoss.encounterID == boss.encounterID then
                                        cachedBoss.killed = true
                                    end
                                end
                            end
                            sharedDifficulty(difficultyID, instanceID, boss.encounterID)
                        end
                    end
                end
            end
        end
    end
end

local eventHandlerFrame = CreateFrame("Frame")
eventHandlerFrame:RegisterEvent("ADDON_LOADED")
eventHandlerFrame:RegisterEvent("FIRST_FRAME_RENDERED")
eventHandlerFrame:RegisterEvent("PLAYER_LOGOUT")
eventHandlerFrame:RegisterEvent("ENCOUNTER_END")

eventHandlerFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            BountyHelperDB = BountyHelperDB or {}
            ignoreList = BountyHelperDB.ignoreList or {}
            hideIgnored = BountyHelperDB.hideIgnored or false
            hideOwned = BountyHelperDB.hideOwned or false
            hideKilled = BountyHelperDB.hideKilled or false
            hideButton = BountyHelperDB.hideButton or false
            lockEsc = BountyHelperDB.lockEsc or false
            currentScale = BountyHelperDB.scale or 1.0
            --if not BountyHelperDB.position then = BountyHelperDB.position = {0, 0} end
            BountyHelperDB.point = BountyHelperDB.point or {"CENTER", 0, 0}

            local LibDBIcon = LibStub("LibDBIcon-1.0")
            LibDBIcon:Register("BountyHelper", LDB, dbBH.minimap)
            buttonBH = LibDBIcon:GetMinimapButton("BountyHelper")
        end
    
    elseif event == "FIRST_FRAME_RENDERED" then
        faction = (UnitFactionGroup("player") == "Alliance") and 1 or 2

        for _, wp in pairs(db.waypoints) do
            if type(wp.point[1]) == "table" then
                wp.point = wp.point[faction]
            end
            wp.name = C_Map.GetMapInfo(wp.point[1]).name
        end

        local journalOverrides = {[329] = 1292}
        local difficultyOverrides = {[556] = 2}
        for _, id in ipairs(db.instanceOrderList) do
            local journalID = journalOverrides[id] or C_EncounterJournal.GetInstanceForGameMap(id)
            local name = EJ_GetInstanceInfo(journalID)
            instanceToMap[id] = {
                journalID = journalID,
                name = name,
                difficultyID = difficultyOverrides[id] or nil
            }
        end

        for instanceID, bosses in pairs(db.bossData) do
            for _, boss in ipairs(bosses) do
                local ejIndex = boss.encounterID
                boss.name, _, _, _, _, _, boss.encounterID = EJ_GetEncounterInfo(ejIndex)
            end
        end

        bountyHelper:initialize()
        bountyHelper.frames.main:SetScale(currentScale)
        bountyHelper.frames.ScaleSlider:SetValue(currentScale)
        bountyHelper.frames.ScaleValueText:SetText(string.format("UI Scale: %.2f", currentScale))

        checkSaved()

        SLASH_CBH1 = "/bh"
        SLASH_CBH2 = "/cbh"
        SLASH_CBH3 = "/bounty"
        SLASH_CBH4 = "/bountyhelper"
        SlashCmdList["CBH"] = function() bountyHelper:Toggle() end
        self:UnregisterEvent("FIRST_FRAME_RENDERED")
        self:UnregisterEvent("ADDON_LOADED")

    elseif event == "PLAYER_LOGOUT" then
        BountyHelperDB.ignoreList = ignoreList
        BountyHelperDB.hideIgnored = hideIgnored
        BountyHelperDB.hideOwned = hideOwned
        BountyHelperDB.hideKilled = hideKilled
        BountyHelperDB.hideButton = hideButton
        BountyHelperDB.lockEsc = lockEsc
        BountyHelperDB.scale = currentScale
        local point, relativeTo, relativePoint, xOfs, yOfs = bountyHelper.frames.main:GetPoint()
        BountyHelperDB.point = { relativePoint, xOfs, yOfs }

    elseif event == "ENCOUNTER_END" then
        local encounterID, _, difficultyID, _, success = ...
        if success == 1 then
            local instanceID = select(8, GetInstanceInfo())
            local boss, bossIndex = findBossByEncounterID(instanceID, encounterID)
            
            if boss and boss.killedAtDiff[difficultyID] ~= nil then
                boss.killedAtDiff[difficultyID] = true
                
                if bountyHelper.difficultyViewData[difficultyID] and bountyHelper.difficultyViewData[difficultyID][instanceID] then
                     for _, cachedBoss in ipairs(bountyHelper.difficultyViewData[difficultyID][instanceID]) do
                        if cachedBoss.encounterID == encounterID then
                            cachedBoss.killed = true
                        end
                    end
                end

                sharedDifficulty(difficultyID, instanceID, encounterID)

                if bountyHelper.frames.main:IsShown() then
                    bountyHelper:UpdateDiffLayout()
                    bountyHelper:updateContent()
                end
            end
        end
    end
end)