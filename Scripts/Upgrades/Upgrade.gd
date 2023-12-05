extends Node

export var UpgradeTitle = "blah"
export var UpgradeDescription = "blah"

export(Array, GameResources.RESOURCE_TYPE) var RequirementType
export(Array, int) var RequirementAmount

# AddJob will enable a job
# UpgradeJob will upgrade a job
export (GameResources.TECH_TYPE) var  TechCommand1

# indicates the inner job name
export var TechCommand2 = ""

# setting value
export var TechCommand3 = ""

signal OnUpgraded

var TechPurchaseButtonClass = preload("res://Prefab/UI/Tech/TechPurchaseButton.tscn")

func _ready():
	add_to_group("PurchaseButton")
	
func AddToTechStore():
	var techStoreButton = TechPurchaseButtonClass.instance()
	techStoreButton.TechTitle = UpgradeTitle
	techStoreButton.TechDescription = UpgradeDescription
	techStoreButton.RequirementType = RequirementType
	techStoreButton.RequirementAmount = RequirementAmount
	techStoreButton.TechCommand1 = TechCommand1
	techStoreButton.TechCommand2 = TechCommand2	
	techStoreButton.TechCommand3 = TechCommand3
	Helper.GetTechPanel().AddToAvailableContainer(techStoreButton)
	techStoreButton.connect("OnPurchased", self, "OnPurchased")
	
func OnPurchased():
	emit_signal("OnUpgraded")
