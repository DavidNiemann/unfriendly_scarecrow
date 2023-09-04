local spawn_chance = 1
local spawn_amount = 13

local assets =
{
    -- Animation files used for the item.
    Asset("ANIM", "anim/sword.zip"),

    -- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/sword.xml"),
    Asset("IMAGE", "images/inventoryimages/sword.tex"),
}
prefabs = {
    "sword",
}


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", -- Symbol to override.
        "sword",                                  -- Animation bank we will use to overwrite the symbol.
        "sword")                                  -- Symbol to overwrite it with.
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function onattack(inst, owner, target)
    if math.random() < spawn_chance then
        local pt
        if target ~= nil and target:IsValid() then
            pt = target:GetPosition()
        else
            pt = owner:GetPosition()
            target = nil
        end

        --[[  inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
            inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2") ]]

        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, NoHoles, false, true)
        if offset ~= nil then
            local tentacle = SpawnPrefab("raven")
            if tentacle ~= nil then
                tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                tentacle.components.combat:SetTarget(target)
            end
        end
    end
end

local function init()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword")
    inst.AnimState:SetBuild("sword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(39)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sword.xml"
    inst.components.inventoryitem.imagename = "sword"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(120)
    inst.components.finiteuses:SetUses(120)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("common/inventory/sword", init, assets, prefabs)
