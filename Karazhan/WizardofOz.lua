﻿------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Crone"]
local roar = AceLibrary("Babble-Boss-2.2")["Roar"]
local tinhead = AceLibrary("Babble-Boss-2.2")["Tinhead"]
local strawman = AceLibrary("Babble-Boss-2.2")["Strawman"]
local dorothee = AceLibrary("Babble-Boss-2.2")["Dorothee"]
local tito = AceLibrary("Babble-Boss-2.2")["Tito"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	spawns = "Spawn Timers",
	spawns_desc = "Timers for when the characters become active",

	light = "Chain Lightning",
	light_desc = "Warn for Chain Lightning being cast",

	spawns_bar = "%s attacks!",
	spawns_warning = "%s in 5 sec",

	light_trigger = "The Crone begins to cast Chain Lightning",
	light_message = "Chain Lightning!",

	engage_trigger = "Oh Tito, we simply must find a way home!",
} end)

L:RegisterTranslations("deDE", function() return {
	spawns = "Spawn Timer",
	spawns_desc = "Zeitanzeige bis die Charaktere Aktiv werden",

	light = "Kettenblitzschlag",
	light_desc = "Warnt wenn Kettenblitzschlag gewirkt wird",

	spawns_bar = "%s greift an!",
	spawns_warning = "%s in 5 sek",

	light_trigger = "Die b\195\182se Hexe beginnt Kettenblitzschlag zu wirken",
	light_message = "Kettenblitzschlag!",

	engage_trigger = "Oh Tito, wir m\195\188ssen einfach einen Weg nach Hause finden!",
} end)

L:RegisterTranslations("frFR", function() return {
	spawns = "Alerte Hostilit\195\169",
	spawns_desc = "Timers pour les diff\195\169rents pops.",

	light = "Cha\195\174ne d'\195\169clairs",
	light_desc = "Pr\195\169viens quand La M\195\169g\195\168re commence \195\160 lancer sa Cha\195\174ne d'\195\169clairs.",

	spawns_bar = "%s attaque !",
	spawns_warning = "%s dans 5 sec",

	light_trigger = "La M\195\169g\195\168re commence \195\160 lancer Cha\195\174ne d'\195\169clairs",
	light_message = "Cha\195\174ne d'\195\169clairs !",

	engage_trigger = "Oh, Tito, nous devons trouver le moyen de rentrer \195\160 la maison\194\160!",
} end)

L:RegisterTranslations("koKR", function() return {
	spawns = "등장 타이머",
	spawns_desc = "피조물 활동 시작에 대한 타이머",

	light = "연쇄 번개",
	light_desc = "연쇄 번개 시전에 대한 경고",

	spawns_bar = "%s 공격!",
	spawns_warning = "5초 이내 %s",

	light_trigger = "마녀가 연쇄 번개 시전을 시작합니다.",
	light_message = "연쇄 번개!",

	engage_trigger = "티토야, 우린 집으로 갈 방법을 찾아야 해!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = {roar, tinhead, strawman, dorothee}
mod.toggleoptions = {"spawns", "light", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) and self.db.profile.spawns then
		self:Bar(L["spawns_bar"]:format(roar), 15, "INV_Staff_08")
		self:DelayedMessage(10, L["spawns_warning"]:format(roar), "Attention")
		self:Bar(L["spawns_bar"]:format(strawman), 25, "Ability_Druid_ChallangingRoar")
		self:DelayedMessage(20, L["spawns_warning"]:format(strawman), "Attention")
		self:Bar(L["spawns_bar"]:format(tinhead), 35, "INV_Chest_Plate06")
		self:DelayedMessage(30, L["spawns_warning"]:format(tinhead), "Attention")
		self:Bar(L["spawns_bar"]:format(tito), 48, "Ability_Hunter_Pet_Wolf")
		self:DelayedMessage(43, L["spawns_warning"]:format(tito), "Attention")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["light_trigger"]) and self.db.profile.light then
		self:Message(L["light_message"], "Urgent")
		self:Bar(L["light_message"], 2.5, "Spell_Nature_ChainLightning")
	end
end
