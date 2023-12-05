extends Panel


var slimeReference = null
onready var slimeName = $VBoxContainer/SlimeName
onready var slimeCurrent = $VBoxContainer/SlimeCurrent

onready var Filters = $VBoxContainer/Filters
onready var CurrentFilter = $VBoxContainer/Filters/ResourceList

onready var ButtonsContainer = $VBoxContainer/ButtonsContainer
var buttonName = ""

func _ready():
	_on_ResourceGatheringButton_button_down()

			
func GetJobs():
	return CurrentFilter.get_child(0).get_children()
	
func Show(slime):
	slimeReference = slime
	slimeName.text = slime.Name
	slimeCurrent.text = slime.GetOutputString()
	visible = true
	
	for job in GetJobs():
		job.UpdateJobVisibility()

func UpdateAllJobs():
	for job in get_tree().get_nodes_in_group("JobObject"):
		job.UpdateJobVisibility()
		
func SetButtonVisibility(button, bIsToggled):
	if bIsToggled:
		button.modulate = "#FFFFFF"
	else:
		button.modulate = "#666666"
		
func UpdateUI():
	for job in GetJobs():
		job.UpdateJobVisibility()
	for node in Filters.get_children():
		node.visible = false
		if node == CurrentFilter:
			node.visible = true
	for node in ButtonsContainer.get_children():
		SetButtonVisibility(node, buttonName == node.name)
	
func _on_CloseButton_button_down():
	Close()

func Close():
	Helper.GetSound().Close()
	visible = false


func _on_ResourceGatheringButton_button_down():
	CurrentFilter = $VBoxContainer/Filters/ResourceList
	buttonName = "ResourceGatheringButton"
	UpdateUI()

func _on_CraftingButton_button_down():
	CurrentFilter = $VBoxContainer/Filters/CraftingList
	buttonName = "CraftingButton"
	UpdateUI()


func _on_DustingButton_button_down():
	CurrentFilter = $VBoxContainer/Filters/DustingList
	buttonName = "DustingButton"
	UpdateUI()
