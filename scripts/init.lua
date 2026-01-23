local variant = Tracker.ActiveVariantUID

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/options.json")

-- Layout
Tracker:AddLayouts("layouts/items_vertical.json")
Tracker:AddLayouts("layouts/items_horizontal.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")

-- Maps
Tracker:AddMaps("maps/maps.json") 
Tracker:AddMaps("maps/overworld.json") 

-- Logic
ScriptHost:LoadScript("scripts/logic/logic_helpers.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Locations
Tracker:AddLocations("locations/(HT2).json")
Tracker:AddLocations("locations/(HT).json")
Tracker:AddLocations("locations/(STT).json")
Tracker:AddLocations("locations/(BC).json")
Tracker:AddLocations("locations/(OC).json")
Tracker:AddLocations("locations/(BC2).json")
Tracker:AddLocations("locations/(AG2).json")
Tracker:AddLocations("locations/(DC).json")
Tracker:AddLocations("locations/GOA.json")
Tracker:AddLocations("locations/(AG).json")
Tracker:AddLocations("locations/(HB2).json")
Tracker:AddLocations("locations/Levels.json")
Tracker:AddLocations("locations/(PL).json")
Tracker:AddLocations("locations/(HB).json")
Tracker:AddLocations("locations/(TR).json")
Tracker:AddLocations("locations/(PR).json")
Tracker:AddLocations("locations/(TWTNW2).json")
Tracker:AddLocations("locations/(SP2).json")
Tracker:AddLocations("locations/(SP).json")
Tracker:AddLocations("locations/(TT2).json")
Tracker:AddLocations("locations/(TT).json")
Tracker:AddLocations("locations/(CoR).json")
Tracker:AddLocations("locations/(OC2).json")
Tracker:AddLocations("locations/(AT).json")
Tracker:AddLocations("locations/(TT3).json")
Tracker:AddLocations("locations/(TWTNW3).json")
Tracker:AddLocations("locations/(100Acre).json")
Tracker:AddLocations("locations/(LoD2).json")
Tracker:AddLocations("locations/(PL2).json")
Tracker:AddLocations("locations/(PR2).json")
Tracker:AddLocations("locations/(LoD).json")
Tracker:AddLocations("locations/(TWTNW).json")
Tracker:AddLocations("locations/Overworld.json")
Tracker:AddLocations("locations/Submaps.json")

-- Missing Slot Data Helpers
Tracker:AddLocations("locations/missing_setting_slotdata.json")
Tracker:AddItems("items/missing_slotdata.json")
Tracker:FindObjectForCode("missing_Superbosses").Active = false
Tracker:FindObjectForCode("missing_Cups").Active = false
Tracker:FindObjectForCode("missing_AtlanticaToggle").Active = false
Tracker:FindObjectForCode("missing_SummonLevelLocationToggle").Active = false

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watch for the changing of the Overworld Map Image used
ScriptHost:AddWatchForCode("opt_summon", "opt_summon", toggle_overworldmap)