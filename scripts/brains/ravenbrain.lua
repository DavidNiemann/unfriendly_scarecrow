--[[ require "behaviours/follow"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"
local BrainCommon = require("brains/braincommon") ]]

require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/chaseandattack"
require "behaviours/standstill"
local BrainCommon = require("brains/braincommon")

--[[ local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30 ]]

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local MAX_WANDER_DIST = 20
local SEE_TARGET_DIST = 6

local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 8

--[[ local RavenBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end) ]]

--[[ local SHOULDFLYAWAY_MUST_TAGS = { "notarget", "INLIMBO" }
local SHOULDFLYAWAY_CANT_TAGS = { "player", "monster", "scarytoprey" }
 ]]
--[[ local function ShouldFlyAway(inst)
    return not (inst.sg:HasStateTag("sleeping") or
                inst.sg:HasStateTag("busy") or
                inst.sg:HasStateTag("flight"))
        and (TheWorld.state.isnight or
            (inst.components.health ~= nil and inst.components.health.takingfiredamage and not (inst.components.burnable and inst.components.burnable:IsBurning())) or
            FindEntity(inst, inst.flyawaydistance, nil, nil, SHOULDFLYAWAY_MUST_TAGS, SHOULDFLYAWAY_CANT_TAGS) ~= nil)
end

local function FlyAway(inst)
    inst:PushEvent("flyaway")
end ]]

local function GoHomeAction(inst)
    if inst.components.homeseeker and
       inst.components.homeseeker.home and
       inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function ShouldGoHome(inst)
    return not TheWorld.state.isday or TheWorld.state.iswinter
end

local RavenBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function RavenBrain:OnStart()
    local root = PriorityNode(
    {
       --[[  WhileNode( function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end, "PanicHaunted",
        ActionNode(function() return FlyAway(self.inst) end)),
   --[[  IfNode(function() return ShouldFlyAway(self.inst) end, "Threat Near",
        ActionNode(function() return FlyAway(self.inst) end)), ]]
   --[[  EventNode(self.inst, "threatnear", ]]
   --[[      ActionNode(function() return FlyAway(self.inst) end)), ]]
--[[    WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
       ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) ),
    EventNode(self.inst, "gohome",
        ActionNode(function() return FlyAway(self.inst) end)), ]]

        BrainCommon.PanicTrigger(self.inst),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
            DoAction(self.inst, function() return GoHomeAction(self.inst) end, "go home", true )),
		WhileNode(function() return TheWorld and not TheWorld.state.isnight end, "IsNotNight",
			Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)),
		StandStill(self.inst, function() return self.inst.sg:HasStateTag("idle") end, nil),
    }, .25)

    self.bt = BT(self.inst, root)
end

return RavenBrain
