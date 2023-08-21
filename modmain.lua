PrefabFiles =
{
	"statuemarblebroodling",
}

Assets =
{
	Asset("ATLAS", "images/statuemarblebroodling.xml"),
	Asset("IMAGE", "images/statuemarblebroodling.tex"),
}

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

-----------------RECIPES---------------
AddRecipe("statuemarblebroodling",
	{
		Ingredient("marble", 4),
	},
	RECIPETABS.TOWN, TECH.SCULPTING_ONE, "statuemarblebroodling_placer", 0.5, nil, nil, nil,
	"images/statuemarblebroodling.xml", "statuemarblebroodling.tex")

modimport("strings.lua")
