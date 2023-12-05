extends Node

var Upgrades

var UpgradeIndex = 0
var bHasBeenUnlocked = false

# Meant to be run, when this upgradeable has been unlocked
signal OnUnlocked

# Meant to be run, when this upgradeable has been upgraded
signal OnUpgraded

func _ready():
	Upgrades = get_children()
	connect("OnUnlocked", self, "SubmitNextUpgradeToStore")
	for upgrade in Upgrades:
		upgrade.connect("OnUpgraded", self, "SubmitNextUpgradeToStore")

func Unlock():
	bHasBeenUnlocked = true
	emit_signal("OnUnlocked")

	
func GetCurrentUpgradeLevel():
	return UpgradeIndex + 1


func SubmitNextUpgradeToStore():
	if UpgradeIndex < len(Upgrades):
		Upgrades[UpgradeIndex].AddToTechStore()
		UpgradeIndex += 1
		Helper.GetSound().Add()
