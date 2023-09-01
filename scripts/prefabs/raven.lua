local brain = require "brains/RavenBrain"

-- if bird is attacked
local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,
        function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function makebird(name, soundname, loottable, psprefab, foodtype, scale)
    local assets =
    {
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/" .. name .. "_build.zip"),
        Asset("SOUND", "sound/birds.fsb")
    }

    local prefabs =
    {
        "cookedsmallmeat",
    }

    prefabs[2] = psprefab or "seeds" -- add the periodspawnprefab to "prefabs" list

    if loottable ~= nil then      -- -- add all loot to "prefabs" list
        for key, loot in pairs(loottable) do
            key = tonumber(key)
            prefabs[key + 2] = loot[1] --key+2 is due to the fact that "prefabs" list already has 2 values in it
        end
    end

    local function fn()
        local inst = CreateEntity()
        --Core components
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:AddPhysics()
        inst.entity:AddAnimState()
        inst.entity:AddDynamicShadow()
        inst.entity:AddSoundEmitter()

        --Initialize physics
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:SetSphere(1)
        inst.Physics:SetMass(1)

        --Tags for inventory search??
        inst:AddTag(name)
        inst:AddTag("smallcreature")
        inst:AddTag("animal")
        inst:AddTag("prey")
        inst:AddTag("frog")

        --Set default for scale
        scale = scale or 1

        inst.Transform:SetTwoFaced()
--[[         inst.AnimState:SetBank("crow")
        inst.AnimState:SetBuild(name .. "_build")
        inst.AnimState:PlayAnimation("idle") ]]
        inst.AnimState:SetBank("frog")
        inst.AnimState:SetBuild("frog")
        inst.AnimState:PlayAnimation("idle")
        inst.DynamicShadow:SetSize(scale, scale - 0.25)
        inst.DynamicShadow:Enable(false)

        inst.Transform:SetScale(scale, scale, scale)
--[[         MakeFeedablePetPristine(inst) ]]

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:SetPristine()

        inst.sounds =
        {
            takeoff = "dontstarve/birds/takeoff_" .. soundname,
            chirp = "dontstarve/birds/chirp_" .. soundname,
            flyin = "dontstarve/birds/flyin",
        }
        inst.trappedbuild = name .. "_build"

        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        inst.components.locomotor:SetTriggersCreep(false)
        inst:SetStateGraph("SGfrog")

        if loottable ~= nil then
            inst:AddComponent("lootdropper")
            inst.components.lootdropper.numrandomloot = 1
            for key, loot in pairs(loottable) do
                inst.components.lootdropper:AddRandomLoot(loot[1], loot[2]) --loot[1] is prefab, loot[2] is rarity
            end
        end

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(TUNING.FROG_DAMAGE)
        inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD)

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(1000)
        inst.components.health.murdersound = "dontstarve/wilson/hit_animal"
        inst:SetBrain(brain)

        MakeSmallBurnableCharacter(inst, "crow_body")
        MakeTinyFreezableCharacter(inst, "crow_body")

        inst:ListenForEvent("attacked", OnAttacked)
        return inst
    end

    return Prefab("forest/animals/" .. name, fn, assets, prefabs)
end

--TEMPLATE
--makebird("prefabname", "soundname", {loottables}, "periodcspawnprefab", FOODTYPE.TYPE, scale, animremap)
return makebird(
    "phoenix",
    "crow",
    { { "bluegem", 0.8 }, { "feather_crow", 1.1 } },
    "bluegem",
    FOODTYPE.ROUGHAGE,
    1.3
)
