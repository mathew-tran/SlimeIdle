extends Button


export var TechTitle = "blah"
export var TechDescription = "blah"

export(Array, GameResources.RESOURCE_TYPE) var RequirementType
export(Array, int) var RequirementAmount

onready var titleLabel = $VBoxContainer/TechTitle
onready var descriptionLabel = $VBoxContainer/TechDescription
onready var requirementLabel = $VBoxContainer/TechRequirements

onready var purchaseLabel = $VBoxContainer/TechPurchaseDate

var bIsPurchased = false

signal OnPurchased

export (GameResources.TECH_TYPE) var  TechCommand1
export var TechCommand2 = ""
export var TechCommand3 = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	titleLabel.text = TechTitle
	descriptionLabel.text = TechDescription
	purchaseLabel.text = ""
	UpdateRequirementText()
	Helper.GetInventory().connect("OnInventoryUpdate", self, "UpdateVisuals")
	
	UpdateVisuals()
	visible = false
	$AnimationPlayer.play("Open")
	
		
func UpdateRequirementText():
	var newText = ""
	
	for x in range(0, len(RequirementType)):
		newText += "(" + str(RequirementAmount[x]) + ") " + GameResources.GetResName(RequirementType[x]) + "\n"
		
	requirementLabel.text = newText
	var lines = requirementLabel.text.count("\n") + titleLabel.text.count("\n") + descriptionLabel.text.count("\n") + 1
	rect_min_size = Vector2(rect_min_size.x, 70 + lines * 12)

func UpdateVisuals():
	
	if bIsPurchased:
		modulate = "#444444"
		return
		
	if CanAfford():
		modulate = "#00FF00"
	else:
		modulate = "#444444"

func CanAfford():
	var inventory = Helper.GetInventory()
	for x in range(0, len(RequirementType)):
		if inventory.CheckIfItemExists(GameResources.GetResName(RequirementType[x]), RequirementAmount[x]) == false:
			return false
	return true

func _on_TechPurchase_button_down():
	if CanAfford() && !bIsPurchased:
		bIsPurchased = true
		var time = OS.get_datetime()
		var display_string : String = "%02d/%02d/%02d" % [time.year, time.month, time.day];
		purchaseLabel.text = "Purchased: " + display_string
		UpdateVisuals()
		var inventory = Helper.GetInventory()
		for x in range(0, len(RequirementType)):
			inventory.RemoveItem(GameResources.GetResName(RequirementType[x]), RequirementAmount[x])
		Helper.GetTechPanel().MoveToPurchasedContainer(self)
		Helper.GetTechPanel().RunTechCommand(TechCommand1, TechCommand2, TechCommand3)
		emit_signal("OnPurchased")
		disabled = true
		
