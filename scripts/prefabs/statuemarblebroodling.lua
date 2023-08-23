---@diagnostic disable: undefined-global
require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/statue_small.zip"),
    Asset("ANIM", "anim/statuemarblebroodling.zip"),
    Asset("MINIMAP_IMAGE", "statuemarblebroodling"),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
}

SetSharedLootTable('statuemarblebroodling',
    {
        { 'marble', 1.0 },
        { 'marble', 0.3 },
    })

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    else
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
            (workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
            "idle"
        )
    end
end

local function OnWorkLoad(inst)
    OnWorked(inst, nil, inst.components.workable.workleft)
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        --[[ inst.AnimState:PlayAnimation("open") ]]

        --[[ if inst.skin_open_sound then
            inst.SoundEmitter:PlaySound(inst.skin_open_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end ]]
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
       --[[  inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false) ]]

       --[[  if inst.skin_close_sound then
            inst.SoundEmitter:PlaySound(inst.skin_close_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        end ]]
    end
end



-- onfullMoon ? brauchen wir das?
local function OnFullMoon(inst, isfullmoon)
    if isfullmoon then
        if not inst.angry then
            inst.angry = true
            inst.AnimState:PlayAnimation("idle_moon")
            inst.AnimState:PushAnimation("idle_moon", false)
        end
    elseif inst.angry then
        inst.angry = nil
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:PushAnimation("idle", false)
    end
end

--[[ command for needed items ingame
    c_give("goldnugget", 10);c_give("twigs", 10);c_give("cutstone", 10);c_give("log", 10);c_give("marble", 10);c_give("rocks", 10);c_give("boards", 10)
]]

--[[ kann man frei alles herstellen
    c_freecrafting()
]]


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)

    inst.entity:AddTag("statue")

    inst.AnimState:SetBank("statuemarblebroodling")
    inst.AnimState:SetBuild("statuemarblebroodling")
    inst.AnimState:PlayAnimation("idle")

    inst.MiniMapEntity:SetIcon("statuemarblebroodling.png")

    inst.entity:SetPristine()

    --[[ if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("cookpot") end
        return inst
    end ]]

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('statuemarblebroodling')

    inst:AddTag("structure")

    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetOnLoadFn(OnWorkLoad)
    inst.components.workable.savestate = true

    --[[ inst:WatchWorldState("isfullmoon", OnFullMoon) ]]

    MakeHauntableWork(inst)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("treasurechest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    return inst
end

return Prefab("statuemarblebroodling", fn, assets, prefabs),
    MakePlacer("statuemarblebroodling_placer", "statuemarblebroodling", "statuemarblebroodling", "idle")
