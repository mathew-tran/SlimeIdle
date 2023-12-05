extends "res://Scripts/Test/Test.gd"

export var bUnlockAllUpgrades = false

func _ready():
	if bUnlockAllUpgrades:
		UnlockAllUpgrades()

func UnlockAllUpgrades():
	var buttons = get_tree().get_nodes_in_group("PurchaseButton")
		
	for button in buttons:
		button.AddToTechStore()
		
func RunTest():
	yield(get_tree().create_timer(1.0), "timeout")
	var buttonNames = []
	var buttons = get_tree().get_nodes_in_group("PurchaseButton")
		
	for button in buttons:
		if button.UpgradeTitle in buttonNames:
			var stringText = str(button.get_path()) + " has upgrade title: " + button.UpgradeTitle + " which is not unique"
			failureReason.append(stringText)
		else:
			buttonNames.append(button.UpgradeTitle)
			
	for button in buttons:
		if len(button.RequirementType) != len(button.RequirementAmount):
			var stringText = str(button.get_path()) + " requirement type and requirement amount does not match"
			failureReason.append(stringText)
			
	return len(failureReason) == 0

func ShowVerbose():
	yield(get_tree().create_timer(1.0), "timeout")
	var buttons = get_tree().get_nodes_in_group("PurchaseButton")
	print("There are a total of " + str(len(buttons)) + " Upgrades")
	for x in range(0, len(buttons)):
		print("[" + str(x+1) + "/" + str(len(buttons)) + "] " + buttons[x].UpgradeTitle)
