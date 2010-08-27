local addon = CreateFrame'Frame'

local function CreateDialogFrame()
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
		CreateDialogFrame()
		self:UnregisterEvent'ADDON_LOADED'
	end
end)

addon:RegisterEvent'ADDON_LOADED'
