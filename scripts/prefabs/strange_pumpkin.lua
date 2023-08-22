-- assets for the Item
local assets =
{
    Asset("ANIM", "anim/strange_pumpkin.zip"),
}

local prefabs =
{
    "pumpkin",
}

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pre_loop")
        -- inst.SoundEmitter:KillSound("snd")
        -- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        -- .SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle_empty")
            inst.SoundEmitter:KillSound("snd")
        end
        -- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end



local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.stewer:Harvest()
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
        ChangeFace(inst, "hit")
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    -- inst.SoundEmitter:PlaySound("dontstarve/common/scarecrow_craft")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.burnt then
            inst.components.burnable.onburnt(inst)
        else
            data = inst.components.playeravatardata:GetData()
            data =
            {
                name = data ~= nil and data.name or nil,
                prefab = data ~= nil and data.prefab or nil,
            }
            inst.components.playeravatardata:SetData(data)
        end
    end
end

local function onloadpostpass(inst, newents, data)
    if data and data.additems and inst.components.container then
        for i, itemname in ipairs(data.additems) do
            local ent = SpawnPrefab(itemname)
            inst.components.container:GiveItem(ent)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst:AddTag("structure")

    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    inst:AddComponent("container")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst.AnimState:PlayAnimation("idle_day")
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    -- dont needed
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnLoadPostPass = onloadpostpass

    return inst
end

return Prefab("strange_pumpkin", fn, assets, prefabs),
    MakePlacer("statuemarblebroodling_placer", "statuemarblebroodling", "statuemarblebroodling", "idle")