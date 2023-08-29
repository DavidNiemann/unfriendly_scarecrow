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
    	"sword", -- Animation bank we will use to overwrite the symbol.
    	"sword") -- Symbol to overwrite it with.
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function fireattack(inst, attacker, target)
    if not target:IsValid() then
        --target killed or removed in combat damage phase
        return
    end
--[[ 
	if target.SoundEmitter ~= nil then
	    target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	end ]]

    target:PushEvent("attacked", {attacker = attacker, damage = 0})
    -- NOTES(JBK): Valid check in case the event removed the target.
    if target:IsValid() then
        if target.components.burnable then
            target.components.burnable:Ignite(nil, attacker)
        end
        if target.components.freezable then
            target.components.freezable:Unfreeze()
        end
        if target.components.health then
            target.components.health:DoFireDamage(0, attacker)
        end
        if target.components.combat then
            target.components.combat:SuggestTarget(attacker)
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
    inst.components.weapon:SetOnAttack(fireattack)
    
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
return  Prefab("common/inventory/sword", init, assets, prefabs)