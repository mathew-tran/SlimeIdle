extends Sprite

signal CompleteJob
signal OnJobStart
signal OnJobStop
signal OnJobUpdate
signal OnSlimeIdled

export var Name = "Mark"

onready var NameLabel = $NameLabel

var slimePictures = [
	preload("res://Art/Slime_Medium_Green2.png"),
	preload("res://Art/Slime_Medium_Green.png"),
	preload("res://Art/Slime_Medium_Blue1.png"),
	preload("res://Art/Slime_Medium_Blue2.png"),
	preload("res://Art/Slime_Medium_Red.png"),
	preload("res://Art/Slime_Medium_Red2.png"),
]

var slimeTexture = null
var bIsFlipped = false
var JobPackage = null
var bIsJobRecurring = false
var JobRequirement = null
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("OnJobStart", self, "CheckOnJobStart")
	connect("OnJobStart", self, "UpdateInventoryTPS")
	connect("OnJobStop", self, "UpdateInventoryTPS")
	$RetryJobTimer.connect("timeout", self, "CheckOnJobStart")
	slimeTexture = slimePictures[rand_range(0, len(slimePictures))]
	bIsFlipped = rand_range(0, 1)
	
func UpdateInventoryTPS():
	Helper.GetInventoryPanel().UpdateInventoryTPS()
	
func CheckOnJobStart():
	if JobRequirement:
		if Helper.GetInventory().CheckIfItemExists(GameResources.GetResName(JobRequirement.ResourceType), JobRequirement.Amount):
			Helper.GetInventory().RemoveItem(GameResources.GetResName(JobRequirement.ResourceType), JobRequirement.Amount)
			$JobTimer.start()
			$RetryJobTimer.stop()
			emit_signal("OnJobUpdate")
		else:
			$JobTimer.stop()
			$RetryJobTimer.start()
			emit_signal("OnJobUpdate")		
			emit_signal("OnSlimeIdled")	
	Helper.GetSlimePanel().UpdateUIBasedOnSlimeIdle()
			
func IsStalled():
	return $RetryJobTimer.time_left != 0
		
func IsIdle():
	return IsStalled() or false == IsWorking()
func StartJob(newJob, bIsInfiniteJob = false, requirementReward = null):
	
	if requirementReward != null:
		JobRequirement = requirementReward
	else:
		JobRequirement = null
		
	bIsJobRecurring = bIsInfiniteJob
	JobPackage = newJob
	
	$JobTimer.wait_time = JobPackage.Duration
	$JobTimer.start()
	emit_signal("OnJobStart")
	
func StopJob():
	JobPackage = null
	JobRequirement = null
	$RetryJobTimer.stop()
	$JobTimer.stop()
	emit_signal("OnJobStop")
	Helper.GetSlimePanel().UpdateUIBasedOnSlimeIdle()
	emit_signal("OnSlimeIdled")
	
func GetJobPercent():
	if JobPackage:
		return 100 - float($JobTimer.time_left / JobPackage.Duration) * 100
	else:
		return 0
	
func _process(delta):
	if JobPackage != null:
		emit_signal("OnJobUpdate")
	
func IsWorking():
	return JobPackage != null
	
func GetCurrentJobName():
	if IsWorking():
		return JobPackage.JobName
	return "Nothing"
	
func _on_JobTimer_timeout():
	emit_signal("CompleteJob")
	ReceiveJobAward()
	

func ReceiveJobAward():
	
	var textToAdd = Name + " completed : " + JobPackage.JobName
	textToAdd += "\nRewards:\n"
	var Inventory = get_tree().get_nodes_in_group("Inventory")[0]
	
	Inventory.AddItem(JobPackage.JobReward)
	textToAdd += JobPackage.JobReward.GetRewardString() + "\n"
	
	Helper.AddMessage(textToAdd)
	
	if bIsJobRecurring == false:
		StopJob()
	else:
		StartJob(JobPackage, true, JobRequirement)

func GetOutputString() -> String:
	var outputString = "OUTPUT:\n"
	if IsWorking():
		if $RetryJobTimer.time_left != 0:
			outputString += "Waiting for materials..."
		else:
			outputString += JobPackage.GetOutputText()
	else:
		outputString += " None"
	return outputString

func GetJobTimer():
	return $JobTimer	
	
func _on_Button_button_down():
	emit_signal("OnSlimePressed")

