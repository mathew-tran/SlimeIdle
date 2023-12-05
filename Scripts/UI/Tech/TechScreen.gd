extends Container


onready var AvailableButton = $VBoxContainer/HBoxContainer/AvailableButton
onready var PurchasedButton = $VBoxContainer/HBoxContainer/PurchasedButton

onready var AvailableContainer = $VBoxContainer/AvailableContainer
onready var AvailableContainerScrollList = $VBoxContainer/AvailableContainer/ScrollContainer/VBoxContainer
onready var PurchasedContainer = $VBoxContainer/PurchasedContainer
onready var PurchasedContainerScrollList = $VBoxContainer/PurchasedContainer/ScrollContainer/VBoxContainer

var SlimeJobReductionAmount = .1
var slimeClass = preload("res://Prefab/Slime.tscn")
var Unlocks = {
	"Jobs" : {
		"Gravel" : {
			"IsEnabled" : false
		},
		"Stone" : {
			"IsEnabled" : false
		},
		"CutStone" : {
			"IsEnabled" : false
		},
		"Wood" : {
			"IsEnabled" : true
		},
		"Mushroom" : {
			"IsEnabled" : true
		},
		"SmallFish" : {
			"IsEnabled" : false
		},
		"Paper" : {
			"IsEnabled" : false
		},
		"DustStone" : {
			"IsEnabled" : false
		},
		"DustMushroom" : {
			"IsEnabled" : false
		},
		"DustWood" : {
			"IsEnabled" : false
		},
		"DustGravel" : {
			"IsEnabled" : false
		},
		"DustSmallFish" : {
			"IsEnabled" : false
		},
		"DustPaper" : {
			"IsEnabled" : false
		},
		"DustCutStone" : {
			"IsEnabled" : false
		},
		"ToGravel" : {
			"IsEnabled" : false
		},
		"ToPaper" : {
			"IsEnabled" : false
		},
		"ToCutStone" : {
			"IsEnabled" : false
		}
	}}

func _ready():
	ClearAvalailableButtons()
	PressAvailableButton()
	
func ClearAvalailableButtons():
	for button in AvailableContainerScrollList.get_children():
		button.queue_free()
func PressAvailableButton():
	TurnOffContainers()
	AvailableContainer.visible = true
	SetButtonVisibility(AvailableButton, true)

func PressPurchasedButton():
	TurnOffContainers()
	PurchasedContainer.visible = true
	SetButtonVisibility(PurchasedButton, true)
	
func _on_AvailableButton_button_down():
	PressAvailableButton()

func _on_PurchasedButton_button_down():
	PressPurchasedButton()

func SetButtonVisibility(button, bIsToggled):
	if bIsToggled:
		button.modulate = "#FFFFFF"
	else:
		button.modulate = "#666666"
	

func TurnOffContainers():
	AvailableContainer.visible = false
	PurchasedContainer.visible = false
	SetButtonVisibility(AvailableButton, false)
	SetButtonVisibility(PurchasedButton, false)
	
func AddToAvailableContainer(techPurchase):
	AvailableContainerScrollList.add_child(techPurchase)
	PressAvailableButton()
	
func MoveToPurchasedContainer(techPurchase):
	techPurchase.get_parent().remove_child(techPurchase)
	PurchasedContainerScrollList.add_child(techPurchase)
	PurchasedContainerScrollList.move_child(techPurchase, 0)
	PressAvailableButton()
	PurchasedButton.text = "Purchased(" + str(PurchasedContainerScrollList.get_child_count()) + ")"
	
func UnlockJob(JobName):
	Unlocks["Jobs"][JobName]["IsEnabled"] = true
	Helper.GetSlimeAssignPanel().UpdateAllJobs()
	
func AddSlime(name):
	var newSlime = slimeClass.instance()
	Helper.GetSlimeGroup().add_child(newSlime)
	newSlime.Name = name
	Helper.GetSlimePanel().UpdateSlimeList()
	
func UpgradeJob(JobName):
	var jobs = get_tree().get_nodes_in_group("Job")
	for job in jobs:
		if job.InnerJobName == JobName:
			job.Upgrade()

func UpdateJobDuration(JobName, Duration):
	var jobs = get_tree().get_nodes_in_group("Job")
	for job in jobs:
		if job.InnerJobName == JobName:
			job.SetJobDuration(float(Duration))

func CheckJobUnlocked(JobName) -> bool:
	var job = Unlocks["Jobs"][JobName]
	return job["IsEnabled"]

func UpgradeSlimeClicker():
	SlimeJobReductionAmount += .2

func GetSlimeClick():
	return SlimeJobReductionAmount
	
# first param is type, second is a string indicating level
func RunTechCommand(TechCommand1, TechCommand2, TechCommand3):
	if TechCommand1 == GameResources.TECH_TYPE.ADDJOB:
		UnlockJob(TechCommand2)
	if TechCommand1 == GameResources.TECH_TYPE.ADDSLIME:
		AddSlime(TechCommand2)
	if TechCommand1 == GameResources.TECH_TYPE.JOBUPGRADEAMOUNT:
		UpgradeJob(TechCommand2)
	if TechCommand1 == GameResources.TECH_TYPE.JOBSETDURATION:
		UpdateJobDuration(TechCommand2, TechCommand3)
	if TechCommand1 == GameResources.TECH_TYPE.UPGRADESLIMECLICK:
		UpgradeSlimeClicker()
