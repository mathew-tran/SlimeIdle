extends Container

var slimeInfoClass = preload("res://Prefab/UI/Slimes/SlimeInfo.tscn")
onready var slimesContainer = $VBoxContainer/ScrollContainer/Slimes


func _ready():
	UpdateSlimeList()
	$JobAssignPanel.rect_size = rect_size
	
	yield(get_tree().create_timer(1.0), "timeout")
	$Upgradeable.Unlock()
	
func UpdateSlimeList():
	for slime in slimesContainer.get_children():
		slime.queue_free()
	var slimes = Helper.GetSlimes()
	for slime in slimes:
		var newSlime = slimeInfoClass.instance()
		
		slimesContainer.add_child(newSlime)
		newSlime.Setup(slime)
		
	UpdateUIBasedOnSlimeIdle()
	
func UpdateUIBasedOnSlimeIdle():
	var slimesIdle = 0
	for slime in slimesContainer.get_children():
		if slime.slimeReference:
			if slime.slimeReference.IsIdle():
				slimesIdle += 1
	if slimesIdle > 0:
		$VBoxContainer/UnusedSlimesLabel.text = str(slimesIdle) + " slimes idle!!"
		$AnimationPlayer.play("AnimateUnusedSlimes")
	else:
		$VBoxContainer/UnusedSlimesLabel.text = ""
		

func GetTPSForResource(inventoryResource):
	var amount = 0.0
	var seconds = 0.0
	for slime in slimesContainer.get_children():
		if slime.slimeReference:
			if slime.slimeReference.IsIdle() == false:
				if GameResources.GetResName(slime.slimeReference.JobPackage.JobReward.ResourceType) == inventoryResource:
					amount += slime.slimeReference.JobPackage.JobReward.Amount
					seconds = slime.slimeReference.JobPackage.Duration
	if seconds == 0:
		return ""
	return str(amount) + " per " + str(seconds) + " seconds"
