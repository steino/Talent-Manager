local addon = CreateFrame'Frame'

local function Init()
	local d = CreateFrame("Frame", "TalentManagerDialog", PlayerTalentFrame, "UIPanelDialogTemplate")

	d:Hide()
	d:EnableMouse(true)
	d:SetFrameStrata("MEDIUM")

	d:SetToplevel(true)
	d:SetWidth(261)
	d:SetHeight(155)
	d:SetPoint("BOTTOMLEFT", PlayerTalentFrame, "BOTTOMRIGHT", -38, 70)

	d.title:SetText("Talent Manager");
	d.buttons = {};
	local name = d:GetName();
	local button;
	for i = 1, 10 do
		button = CreateFrame("CheckButton", "TalentButton" .. i, d, "GearSetButtonTemplate");
		if ( i == 1 ) then
			button:SetPoint("TOPLEFT", d, "TOPLEFT", 16, -32);
		elseif ( mod(i, NUM_GEARSETS_PER_ROW) == 1 ) then
			button:SetPoint("TOP", "TalentButton"..(i-NUM_GEARSETS_PER_ROW), "BOTTOM", 0, -10);
		else
			button:SetPoint("LEFT", "TalentButton"..(i-1), "RIGHT", 13, 0);
		end
		button.icon = _G["TalentButton" .. i .. "Icon"];
		button.text = _G["TalentButton" .. i .. "Name"];
		tinsert(d.buttons, button);
	end

	local s = CreateFrame("CheckButton", "TalentManagerSaveSpec", d, "UIPanelButtonTemplate")

	s:SetHeight(22)
	s:SetWidth(78)
	s:SetText"Save"

	s:SetPoint("BOTTOMRIGHT", d, -8, 12)
	
	local l = CreateFrame("CheckButton", "TalentManagerLoadSpec", d, "UIPanelButtonTemplate")

	l:SetHeight(22)
	l:SetWidth(78)
	l:SetText"Load"

	l:SetPoint("BOTTOMLEFT", d, 93, 12)
	
	local del = CreateFrame("CheckButton", "TalentManagerDelSpec", d, "UIPanelButtonTemplate")

	del:SetHeight(22)
	del:SetWidth(78)
	del:SetText"Delete"

	del:SetPoint("BOTTOMLEFT", d, 11, 12)
	
	local b = CreateFrame("CheckButton", "TalentManagerTab", PlayerTalentFrame, "PlayerSpecTabTemplate,SecureActionButtonTemplate")
	
	b:SetPoint("TOPLEFT", PlayerSpecTab3, "BOTTOMLEFT", 0, -22)
	b:Show()
	b:SetScript("OnClick", function(self, button, down)
		if self.selected then
			TalentManagerDialog:Hide()
			self:SetChecked(nil)
			self.selected = nil
		else
			TalentManagerDialog:Show()
			self:SetChecked(1)
			self.selected = true
		end
	end)
	b:SetScript("OnEnter", nil)
end

local function GetTalents()
	local p = ""
	for tree = 1, GetNumTalentTabs() do
		for talent = 1, GetNumTalents(tree) do
			prank = select(9, GetTalentInfo(tree, talent))
			p = p .. prank
		end
	end
	return p
end

local function RunPreview(t)
	ResetGroupPreviewTalentPoints()
	local tree = 1
	local talent = 0
	for p in t:gmatch"%d" do
		talent = talent+1
		AddPreviewTalentPoints(tree, talent, p)
		if talent == GetNumTalents(tree) then talent = 0 tree = tree + 1 end
	end
end

addon:SetScript('OnEvent', function(self, event, addon, ...)
	if addon == "Blizzard_TalentUI" then
		Init()
		self:UnregisterEvent'ADDON_LOADED'
	end
end)

addon:RegisterEvent'ADDON_LOADED'
