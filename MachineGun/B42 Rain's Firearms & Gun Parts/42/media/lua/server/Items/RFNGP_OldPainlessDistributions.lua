require 'Items/ProceduralDistributions'
require "Items/ItemPicker"

local sBVars = SandboxVars.OldPainless;

	table.insert(ProceduralDistributions["list"]["ArmyHangarOutfit"].items, "Base.OldPainless");
	table.insert(ProceduralDistributions["list"]["ArmyHangarOutfit"].items, sBVars.Rate);
	table.insert(ProceduralDistributions["list"]["ArmyHangarMechanics"].items, "Base.OldPainless");
	table.insert(ProceduralDistributions["list"]["ArmyHangarMechanics"].items, sBVars.Rate);	
	table.insert(ProceduralDistributions["list"]["ArmyHangarTools"].items, "Base.OldPainless");
	table.insert(ProceduralDistributions["list"]["ArmyHangarTools"].items, sBVars.Rate);
	table.insert(ProceduralDistributions["list"]["ArmyStorageGuns"].items, "Base.OldPainless");
	table.insert(ProceduralDistributions["list"]["ArmyStorageGuns"].items, sBVars.Rate);
	table.insert(VehicleDistributions.ArmyHeavyTruckBed.items, "Base.OldPainless");
	table.insert(VehicleDistributions.ArmyHeavyTruckBed.items, sBVars.Rate);
	table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, "Base.OldPainless");
	table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, sBVars.Rate);