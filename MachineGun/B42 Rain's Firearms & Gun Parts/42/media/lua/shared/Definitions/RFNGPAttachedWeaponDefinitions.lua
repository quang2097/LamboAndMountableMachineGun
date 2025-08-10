require 'Definitions/AttachedWeaponDefinitions'

table.insert(AttachedWeaponDefinitions["handgunHolster"].weapons, "Base.Glock17")
table.insert(AttachedWeaponDefinitions["handgunHolster"].weapons, "Base.HKUSP")
table.insert(AttachedWeaponDefinitions["handgunHolster"].weapons, "Base.SmithWessonM29")

table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.AR15")
table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.DoubleBarrelShotgun")
table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.MossbergM590T")
table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.RemingtonM1187")
table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.MP5")
table.insert(AttachedWeaponDefinitions["shotgunPolice"].weapons, "Base.SPAS12")

table.insert(AttachedWeaponDefinitions["assaultRifleOnBack"].weapons, "Base.ColtCommando")
table.insert(AttachedWeaponDefinitions["assaultRifleOnBack"].weapons, "Base.G3")

table.insert(AttachedWeaponDefinitions["huntingRifleOnBack"].weapons, "Base.MarlinM1894")

AttachedWeaponDefinitions.SoldierBasic= {
	id = "SoldierBasic",
	chance = 25,
	outfit = {"ArmyInstructor", "ArmyCamoDesert", "ArmyCamoGreen"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.M16A1",
		"Base.AssaultRifle",
		"Base.AssaultRifle2",
	},
}

AttachedWeaponDefinitions.SoldierRare= {
	id = "SoldierRare",
	chance = 10,
	outfit = {"ArmyInstructor", "ArmyCamoDesert", "ArmyCamoGreen"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.MossbergM590T",
		"Base.ColtCommando",
		"Base.G3",
		"Base.RemingtonM24",
		"Base.MP5",
		"Base.MP5SD",
	},
}

AttachedWeaponDefinitions.SoldierVeryRare= {
	id = "SoldierVeryRare",
	chance = 1,
	outfit = {"ArmyInstructor", "ArmyCamoDesert", "ArmyCamoGreen"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.AA12",
		"Base.M60",
		"Base.M249",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.ArmyInstructor = {
	chance = 25;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SoldierBasic, 
		AttachedWeaponDefinitions.SoldierRare, 
		AttachedWeaponDefinitions.SoldierVeryRare, 
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.ArmyCamoDesert = {
	chance = 25;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SoldierBasic, 
		AttachedWeaponDefinitions.SoldierRare, 
		AttachedWeaponDefinitions.SoldierVeryRare, 
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.ArmyCamoGreen = {
	chance = 25;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SoldierBasic, 
		AttachedWeaponDefinitions.SoldierRare, 
		AttachedWeaponDefinitions.SoldierVeryRare, 
	},
}

AttachedWeaponDefinitions.BanditRifle= {
	id = "BanditRifle",
	chance = 5,
	outfit = {"Bandit"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.AK47",
		"Base.RK62",
		"Base.RK95",
		"Base.Galil",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Bandit = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.BanditRifle,  
	},
}

AttachedWeaponDefinitions.BikerHandgun= {
	id = "BikerHandgun",
	chance = 5,
	outfit = {"Biker"},
	weaponLocation = {"Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Pistol2",
		"Base.Pistol3",
		"Base.Revolver",
		"Base.Revolver_Long",
		"Base.SmithWessonM29",
		"Base.WinM1887",
		"Base.MAC10",
		"Base.P226",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Biker = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.BikerHandgun,  
	},
}

AttachedWeaponDefinitions.GhillieGunOnBack= {
	id = "GhillieGunOnBack",
	chance = 25,
	outfit = {"Ghillie"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.RemingtonM24",
		"Base.G3",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Ghillie = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.GhillieGunOnBack,  
	},
}

AttachedWeaponDefinitions.HunterGunOnBack= {
	id = "HunterGunOnBack",
	chance = 5,
	outfit = {"Hunter"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.DoubleBarrelShotgun",
		"Base.RemingtonM1187",
		"Base.VarmintRifle",
		"Base.HuntingRifle",
		"Base.MarlinM1894",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Hunter = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.HunterGunOnBack,  
	},
}

AttachedWeaponDefinitions.RangerHandgun= {
	id = "RangerHandgun",
	chance = 25,
	outfit = {"Ranger"},
	weaponLocation = {"Holster Right"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Pistol",
		"Base.Glock17",
		"Base.SmithWessonM29",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Ranger = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.RangerHandgun,  
	},
}

AttachedWeaponDefinitions.SurvivalistGunOnBack= {
	id = "SurvivalistGunOnBack",
	chance = 5,
	outfit = {"Survivalist", "Survivalist02", "Survivalist03"},
	weaponLocation = {"Rifle On Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.DoubleBarrelShotgunSawnoff",
		"Base.SKS56",
		"Base.AK47",
		"Base.RK62",
		"Base.RK95",
		"Base.Galil",
		"Base.VarmintRifle",
		"Base.ColtCommando",
		"Base.G3",
		"Base.Thompson",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Survivalist = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SurvivalistGunOnBack,  
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Survivalist02 = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SurvivalistGunOnBack,  
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Survivalist03 = {
	chance = 20;
	maxitem = 1;
	weapons = {
		AttachedWeaponDefinitions.SurvivalistGunOnBack,  
	},
}