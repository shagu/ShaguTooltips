GameTooltip:SetBackdrop({ 
  bgFile = "Interface\\AddOns\\ShaguTooltips\\img\\bg", tile = true, tileSize = 8,
  edgeFile = "Interface\\AddOns\\ShaguTooltips\\img\\border", edgeSize = 16, 
  insets = {left = 0, right = 0, top = 0, bottom = 0}, })

GameTooltipStatusBar:SetHeight(6)
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetBackdrop( { bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                    insets = {left = -1, right = -1, top = -1, bottom = -1} })
GameTooltipStatusBar:SetBackdropColor(0, 0, 0, 1)

GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 1, 2)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -1, 2)
GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\ShaguTooltips\\img\\normTex")

function round(input, places)
  if not places then places = 0 end
  if type(input) == "number" and type(places) == "number" then
    local pow = 1
    for i = 1, places do pow = pow * 10 end
    return floor(input * pow + 0.5) / pow
  end
end

local ShaguUITooltip = CreateFrame('Frame', nil, GameTooltip) ShaguUITooltip:SetAllPoints()

local ShaguUITooltipStatusBar = CreateFrame('Frame', nil, GameTooltipStatusBar) ShaguUITooltip:SetAllPoints()
ShaguUITooltipStatusBar:SetScript("OnUpdate", function()
    if(not UnitExists('mouseover')) then return end
    local _, class = UnitClass("mouseover")
    local reaction = UnitReaction("mouseover", "player")

    local hp = UnitHealth("mouseover")
    local hpm = UnitHealthMax("mouseover")

    if ShaguUITooltipStatusBar.HP == nil then
      ShaguUITooltipStatusBar.HP = GameTooltipStatusBar:CreateFontString("Status", "DIALOG", "GameFontNormal")
      ShaguUITooltipStatusBar.HP:SetPoint("TOP", 0,8)
      ShaguUITooltipStatusBar.HP:SetNonSpaceWrap(false)
      ShaguUITooltipStatusBar.HP:SetFontObject(GameFontWhite)
      ShaguUITooltipStatusBar.HP:SetFont("Interface\\AddOns\\ShaguUI\\fonts\\arial.ttf", 12, "OUTLINE")
    end

    if hp and hpm then
      if hp >= 1000 then hp = round(hp / 1000, 1) .. "k" end
      if hpm >= 1000 then hpm = round(hpm / 1000, 1) .. "k" end
      ShaguUITooltipStatusBar.HP:SetText(hp .. " / " .. hpm)
    end

    if class and reaction then
      if UnitIsPlayer("mouseover") then
        local color = RAID_CLASS_COLORS[class]
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
      else
        local color = UnitReactionColor[reaction]
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
      end
    end
  end)

local ShaguUITooltipEvent = CreateFrame("Frame")
ShaguUITooltipEvent:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
ShaguUITooltipEvent:SetScript("OnEvent", function()

    local pvpname = UnitPVPName("mouseover")
    local name = UnitName("mouseover")
    local target = UnitName("mouseovertarget")
    local _, targetClass = UnitClass("mouseovertarget")
    local targetReaction = UnitReaction("player","mouseovertarget")
    local _, class = UnitClass("mouseover")
    local guild = GetGuildInfo("mouseover")
    local reaction = UnitReaction("player", "mouseover")
    local pvptitle = gsub(pvpname," "..name, "", 1)

    if class and name and reaction then
      if UnitIsPlayer("mouseover") then
        local color = RAID_CLASS_COLORS[class]
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        GameTooltip:SetBackdropBorderColor(color.r, color.g, color.b)
        GameTooltipTextLeft1:SetText("|cff" .. string.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) .. name)
      else
        local color = UnitReactionColor[reaction]
        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
        GameTooltip:SetBackdropBorderColor(color.r, color.g, color.b)
      end

      if pvptitle ~= name then
        GameTooltip:AppendText(" |cff666666["..pvptitle.."]|r")
      end
    end

    if guild then
      GameTooltip:AddLine("<" .. guild .. ">", 0.3, 1, 0.5)
    end

    if target and ( targetClass or targetReaction ) then
      if UnitIsPlayer("mouseovertarget") then
        local color = RAID_CLASS_COLORS[targetClass]
        GameTooltip:AddLine(target, color.r, color.g, color.b)
      elseif targetReaction ~= nil then
        local color = UnitReactionColor[targetReaction]
        GameTooltip:AddLine(target, color.r, color.g, color.b)
      end
    end

    GameTooltip:Show()
  end)
