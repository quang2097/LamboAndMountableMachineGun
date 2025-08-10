require 'Items/Distributions'
require 'Items/ProceduralDistributions'
require 'Items/SuburbsDistributions'
require 'Vehicles/VehicleDistributions'
require "Items/ItemPicker"

Distributions = Distributions or {};

local distributionTable = {

	RFNGP_PistolCase_Glock = RFNGP_PistolCase_Glock,
	RFNGP_PistolCase_HKM23 = RFNGP_PistolCase_HKM23,
	RFNGP_GunCase_Moss = RFNGP_GunCase_Moss,
	RFNGP_GunCase_1187 = RFNGP_GunCase_1187,
	RFNGP_GunCase_SPAS12 = RFNGP_GunCase_SPAS12,
	RFNGP_GunCase_AR15 = RFNGP_GunCase_AR15,
	RFNGP_GunCase_AK47 = RFNGP_GunCase_AK47,
	RFNGP_GunCase_RK62 = RFNGP_GunCase_RK62,
	RFNGP_GunCase_Galil = RFNGP_GunCase_Galil,
	RFNGP_GunCase_M16A1 = RFNGP_GunCase_M16A1,
	RFNGP_GunCase_ColtCommando = RFNGP_GunCase_ColtCommando,
	RFNGP_GunCase_G3 = RFNGP_GunCase_G3,
	RFNGP_GunCase_RemingtonM24 = RFNGP_GunCase_RemingtonM24,
	RFNGP_GunCase_M60 = RFNGP_GunCase_M60,
	RFNGP_GunCase_M249 = RFNGP_GunCase_M249,
	RFNGP_GunCase_AA12 = RFNGP_GunCase_AA12,

	RFNGP_PistolCase_Glock = {
        rolls = 1,
        items = {
            "Glock17", 200,
            "GlockMagazine", 50,
            "GlockMagazine", 20,
            "GlockMagazine", 10,
            "Bullets9mmBox", 50,
            "Bullets9mmBox", 20,
            "Bullets9mmBox", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_PistolCase_HKM23 = {
        rolls = 1,
        items = {
            "HKM23", 200,
            "45Suppressor", 50,
            "USPClip", 50,
            "USPClip", 20,
            "USPClip", 10,
            "Bullets45Box", 50,
            "Bullets45Box", 20,
            "Bullets45Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_Moss = {
        rolls = 1,
        items = {
            "MossbergM590T", 200,
            "ShotgunShellsBox", 50,
            "ShotgunShellsBox", 20,
            "ShotgunShellsBox", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_1187 = {
        rolls = 1,
        items = {
            "RemingtonM1187", 200,
            "ShotgunShellsBox", 50,
            "ShotgunShellsBox", 20,
            "ShotgunShellsBox", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_SPAS12 = {
        rolls = 1,
        items = {
            "SPAS12", 200,
            "SOCOMRedDot", 50,
            "ShotgunShellsBox", 50,
            "ShotgunShellsBox", 20,
            "ShotgunShellsBox", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_AR15 = {
        rolls = 1,
        items = {
            "AR15", 200,
            "556Clip", 50,
            "556Clip", 20,
            "556Clip", 10,
            "556Box", 50,
            "556Box", 20,
            "556Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_AK47 = {
        rolls = 1,
        items = {
            "AK47", 200,
            "762x39Clip", 50,
            "762x39Clip", 20,
            "762x39Clip", 10,
            "762x39Box", 50,
            "762x39Box", 20,
            "762x39Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_RK62 = {
        rolls = 1,
        items = {
            "RK62", 200,
            "762x39Clip", 50,
            "762x39Clip", 20,
            "762x39Clip", 10,
            "762x39Box", 50,
            "762x39Box", 20,
            "762x39Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_Galil = {
        rolls = 1,
        items = {
            "Galil", 200,
            "556Clip50", 50,
            "556Clip50", 20,
            "556Clip50", 10,
            "556Box", 50,
            "556Box", 20,
            "556Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_M16A1 = {
        rolls = 1,
        items = {
            "M16A1", 200,
            "556Clip", 50,
            "556Clip", 20,
            "556Clip", 10,
            "556Box", 50,
            "556Box", 20,
            "556Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_ColtCommando = {
        rolls = 1,
        items = {
            "ColtCommando", 200,
            "223556Suppressor", 50,
            "556Clip", 50,
            "556Clip", 20,
            "556Clip", 10,
            "556Box", 50,
            "556Box", 20,
            "556Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_G3 = {
        rolls = 1,
        items = {
            "G3", 200,
            "308762Suppressor", 50,
            "M14Clip", 50,
            "M14Clip", 20,
            "M14Clip", 10,
            "762Box", 50,
            "762Box", 20,
            "762Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_RemingtonM24 = {
        rolls = 1,
        items = {
            "RemingtonM24", 200,
            "308762Suppressor", 50,
            "x8ACOGScope", 50,
            "MMRecoilPad", 50,
            "762Box", 50,
            "762Box", 20,
            "762Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_M60 = {
        rolls = 1,
        items = {
            "M60", 200,
            "M60Clip", 50,
            "M60Clip", 20,
            "M60Clip", 10,
            "762Box", 50,
            "762Box", 20,
            "762Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_M249 = {
        rolls = 1,
        items = {
            "M249", 200,
            "M249Clip", 50,
            "M249Clip", 20,
            "M249Clip", 10,
            "556Box", 50,
            "556Box", 20,
            "556Box", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

	RFNGP_GunCase_AA12 = {
        rolls = 1,
        items = {
            "AA12", 200,
            "12gSuppressor", 50,
            "RecoilPad", 50,
            "Laser", 50,
            "AA12Magazine", 50,
            "AA12Magazine", 20,
            "AA12Magazine", 10,
            "ShotgunShellsBox", 50,
            "ShotgunShellsBox", 20,
            "ShotgunShellsBox", 10,
        },
        junk = {
            rolls = 1,
            items = {
                
            }
        }
    },

}

table.insert(Distributions, 1, distributionTable);