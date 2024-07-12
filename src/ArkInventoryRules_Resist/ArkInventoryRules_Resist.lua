local rule = ArkInventoryRules:NewModule( 'ArkInventoryRules_Resist' )
local TTH = nil

function ArkInventoryRules_Resist_RegisterTTH(tooltip)
	TTH = tooltip
end

function rule:OnEnable()
	ArkInventoryRules.Register(self, 'RESIST', rule.resist)
end

local function getTooltipResistances(tooltip)
	local lines = {}
	local tooltipLines = {tooltip:GetRegions()}
	
	for _, line in ipairs(tooltipLines) do
		if(line:IsObjectType('FontString')) then
			table.insert(lines, line:GetText())
		end
	end
	
	return lines
end

function rule.resist(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then
		return false
	end
	
	local ac = select('#', ...)
	local query = {}
	
	local fn = 'resist'
	
	TTH:ClearLines()
	TTH:SetOwner(UIParent)
	TTH:SetHyperlink(ArkInventoryRules.Object.h)
	local lines = getTooltipResistances(TTH)
	TTH:Hide()
	
	local resistLines = {}
	
	for _, line in ipairs(lines) do
		line = string.lower(line)
		if(not string.find(line, '%(%d+%) set:') and string.find(line, '%+%d+ [acdefhinorstuw]+ resistance')) then
			table.insert(resistLines, line)
		end
	end
	
	if(table.getn(resistLines) == 0) then
		return false
	end
	
	if(ac == 0) then
		return true
	end
	
	for ax = 1, ac do
		local arg = select(ax, ...)
		
		if type(arg) == "string" then
			for _, line in ipairs(resistLines) do
				line = string.lower(line)
				if(string.find(line, '%+%d+ ' .. arg .. ' resistance')) then
					return true
				end
			end
		else
			error(string.format(ArkInventory.Localise["RULE_FAILED_ARGUMENT_IS_INVALID"], fn, ax, string.format( "%s", ArkInventory.Localise["STRING"]), 0))
		end
	end
	
	return false
end