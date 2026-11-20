PrefabFiles = {
    "scythe",
    "raven",
}

Assets =
{
    Asset("ATLAS", "images/inventoryimages/raven.xml"),
    Asset("ANIM", "anim/raven_build.zip"),
}
GLOBAL.STRINGS.NAMES.SCYTHE = "Raven Scythe"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SCYTHE = "A sharp, crow looking scythe!"
GLOBAL.STRINGS.RECIPE_DESC.SCYTHE = "A sharp, crow looking scythe!"


GLOBAL.STRINGS.NAMES.RAVEN = "Raven"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAVEN = "Please don't set anything on fire."

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

local scythe = GLOBAL.Recipe("scythe", { Ingredient("twigs", 2), Ingredient("flint", 8), Ingredient("rocks", 2) },
    RECIPETABS.WAR, { SCIENCE = 2 })
scythe.atlas = "images/inventoryimages/scythe.xml"
