extends "res://Scripts/UI/Slimes/Job.gd"


export(GameResources.RESOURCE_TYPE) var InResourceType
export var InResourceAmount = 1

var InReward

func AssignSlime(slime):
	slime.StartJob(GetJob(), $VBoxContainer/CheckBox.pressed, InReward)

func _ready():
	Helper.GetInventory().connect("OnInventoryUpdate", self, "UpdateUI")
	$VBoxContainer/JobInput.text = str(InResourceAmount) + " " +  GameResources.GetResName(InResourceType)
	$VBoxContainer/JobInput.text += " -> " + str(Amount) + " " + GameResources.GetResName(RewardType)
	UpdateUI()
	InReward = GameResources.Reward.new()
	InReward.ResourceType = InResourceType
	InReward.Amount = InResourceAmount
	

func UpdateUI():
	pass
