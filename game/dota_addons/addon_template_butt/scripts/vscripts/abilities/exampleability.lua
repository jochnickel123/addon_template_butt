exampleability = class({})

function exampleability:OnSpellStart()
	local waiter = false
	GameRules:GetGameModeEntity():SetThink(function()
			waiter = true
	end, 1)
	repeat
		local useless = false
	until (true==waiter)
end



-------------------------------------------------------------------------------------------------------------------------------
-- everything down from here is a modifier. LinkLuaModifier adds it to the game, so the AddNewModifier(..) knows where to find it.

--               modifiername used below ,       filepath            , weird valve thing
LinkLuaModifier( "exampleabilitymodifier", "abilities/exampleability", LUA_MODIFIER_MOTION_NONE )

exampleabilitymodifier = class({})

function exampleabilitymodifier:GetTexture() return "item_lifesteal" end

function exampleabilitymodifier:OnCreated( kv )
	-- we have to read the "lifesteal" number from the AddNewModifer(..) to use it.
	self.lifesteal = kv.lifesteal
end

function exampleabilitymodifier:OnRefresh( kv )
	self.lifesteal = kv.lifesteal
end

function exampleabilitymodifier:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED, -- OnAttackLanded (check the link below)
		-- MODIFIER_EVENT_ON_TELEPORTED, -- OnTeleported 
		-- MODIFIER_PROPERTY_MANA_BONUS, -- GetModifierManaBonus 

		-- can contain everything from the API
		-- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API

	}
end

-- function exampleabilitymodifier:GetModifierManaBonus(event) -- MODIFIER_PROPERTY_MANA_BONUS
	-- return 100
-- end

function exampleabilitymodifier:OnAttackLanded(event) -- MODIFIER_EVENT_ON_ATTACK_LANDED
	if self:GetParent()~=event.attacker then return end
	self:GetParent():Heal(self.lifesteal, self:GetAbility())
	self:GetParent():newParticleEffect(BUTT_PARTICLE_LIFESTEAL)
	self.lifesteal = self.lifesteal / 2
end
