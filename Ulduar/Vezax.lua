----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["General Vezax"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33271
mod.toggleoptions = {"flame", "surge", "spawn", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
started = true
add = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Vezax",
	
	flame = "Searing Flames",
	flame_desc = "Warn when Ignis casts a Searing Flames.",
	flame_message = "Searing Flames!",
	
	surge = "Surge of Darkness",
	surge_desc = "Warn when Vezax gains Surge of Darkness.",
	surge_message = "Surge of Darkness!",
	surge_cast = "Surge of Darkness casting!",
	surge_end = "Surge of Darkness faded!",
	
	spawn = "spawn Warnings",
	spawn_desc = "Warn for adds",
	spawn_warning = "spawn soon",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	flame = "이글거리는 불길",
	flame_desc = "이글거리는 불길의 시전을 알립니다.",
	flame_message = "이글거리는 불길!",
	
	surge = "어둠 쇄도",
	surge_desc = "베작스의 어둠 쇄도 획득을 알립니다.",
	surge_message = "어둠 쇄도!",
	surge_cast = "어둠 쇄도 시전!",
	surge_end = "어둠 쇄도 사라짐!",
	
	spawn = "소환 경고",
	spawn_desc = "소환을 알립니다",
	spawn_warning = "곧 소환!",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Flame", 62661)
	self:AddCombatListener("SPELL_CAST_START", "Surge", 62662)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("UNIT_HEALTH")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	--self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame(_, spellID)
	if db.flame then
		self:IfMessage(L["flame_message"], "Attention", spellID)
	end
end

function mod:Surge(_, spellID)
	if db.surge then
		self:IfMessage(L["surge_message"], "Attention", spellID)
		self:Bar(L["surge_cast"], 3, spellID)
	end
end

function mod:SurgeGain(_, spellID)
	if db.surge then
		self:Bar(L["surge"], 10, spellID)
		self:DelayedMessage(10, L["surge_end"], "Attention")
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.spawn then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 26 and hp <= 29 and not add then
			self:Message(L["spawn_warning"], "Positive")
			add = true
		elseif hp > 40 and add then
			add = false
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		add = nil
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end
