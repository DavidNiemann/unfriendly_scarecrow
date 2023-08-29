PrefabFiles = {
    "sword",
}
GLOBAL.STRINGS.NAMES.SWORD = "Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD = "A very sharp and strong sword!"
GLOBAL.STRINGS.RECIPE_DESC.SWORD = "A very sharp and strong sword!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD = "A very sharp and strong sword!"

        STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH

        local sword = GLOBAL.Recipe("sword",{ Ingredient("twigs", 2), Ingredient("flint", 8), Ingredient("rocks", 2) },                     
        RECIPETABS.WAR, {SCIENCE=2})
        sword.atlas = "images/inventoryimages/sword.xml"