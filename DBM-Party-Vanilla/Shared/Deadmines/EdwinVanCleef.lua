local mod	= DBM:NewMod("EdwinVanCleef", "DBM-Party-Vanilla", DBM:IsRetail() and 18 or 5)
local L		= mod:GetLocalizedStrings()

if mod:IsRetail() then
	mod.statTypes = "timewalker"
else
	mod.statTypes = "normal"
end

mod:SetRevision("20241103114940")
mod:SetCreatureID(639)
mod:SetEncounterID(2972)--Retail Encounter ID
mod:SetZone(36)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 5200",
	"SPELL_AURA_APPLIED 3391"
)

local warningThrash					= mod:NewSpellAnnounce(3391, 3)
local warningAllies					= mod:NewSpellAnnounce(5200, 3)

local timerTrashD					= mod:NewAITimer(180, 3391, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

function mod:OnCombatStart(delay)
	timerTrashD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpell(5200) and self:AntiSpam(3, 1) then
		warningAllies:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpell(3391) and args:IsDestTypeHostile() then
		warningThrash:Show()
		timerTrashD:Start()
	end
end
