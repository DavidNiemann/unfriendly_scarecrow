require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"
local BrainCommon = require("brains/braincommon")

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local MAX_WANDER_DIST = 20
local SEE_TARGET_DIST = 6

local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 8
local FIND_TARGET_DIST = 15 -- search radius around the player for a new target

local TARGET_MUST_TAGS = { "_combat", "_health" }
local TARGET_CANT_TAGS = { "INLIMBO", "player", "playerghost", "companion", "wall", "raven", "notarget" }

-- next enemy near the owner: anything hostile or anything attacking the owner
local function FindNewTarget(inst)
    local owner = inst.owner
    if owner == nil or not owner:IsValid() then
        return nil
    end
    return FindEntity(owner, FIND_TARGET_DIST, function(guy)
        return not guy.components.health:IsDead()
            and inst.components.combat:CanTarget(guy)
            and (guy:HasTag("hostile") or guy:HasTag("monster") or guy.components.combat.target == owner)
    end, TARGET_MUST_TAGS, TARGET_CANT_TAGS)
end

local RavenBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function RavenBrain:OnStart()
    local root = PriorityNode(
    {
		--[[ BrainCommon.PanicTrigger(self.inst), ]]
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        -- target dead or lost -> attack next enemy near the player, otherwise fly away
        ActionNode(function()
            local target = FindNewTarget(self.inst)
            if target ~= nil then
                self.inst.components.combat:SetTarget(target)
            else
                self.inst:PushEvent("flyaway")
            end
        end),
    }, .25)

    self.bt = BT(self.inst, root)
end

return RavenBrain
