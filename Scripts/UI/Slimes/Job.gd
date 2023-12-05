extends Button

export var JobName = "JobName"
export var Duration = 4
export var InnerJobName = "InnerJobName"

signal OnJobUnlock
signal OnJobComplete


export(GameResources.RESOURCE_TYPE) var RewardType
export(int) var Amount

var bHasUnlocked = false
var Job

func _ready():
	add_to_group("JobObject")
	$VBoxContainer/JobName.text = JobName
	Job = GameResources.Job.new()
	Job.JobName = JobName	
	Job.Duration = Duration
	
	var reward = GameResources.Reward.new()
	reward.Amount = Amount
	reward.ResourceType = RewardType
	Job.JobReward = reward
	$VBoxContainer/JobOutput.text = Job.GetOutputText()
	connect("OnJobUnlock", self, "OnJobUnlocked")
	UpdateJobVisibility()
	
	
func OnJobUnlocked():
	if get_node("Upgradeable"):
		yield(get_tree().create_timer(1.0), "timeout")
		$Upgradeable.Unlock()
		
func Upgrade():
	Job.JobReward.Amount += 1
	$VBoxContainer/JobOutput.text = Job.GetOutputText()
	
func SetJobDuration(amount):
	Job.Duration = amount
	$VBoxContainer/JobOutput.text = Job.GetOutputText()
	
func UpdateJobVisibility():
	var bIsUnlocked = Helper.GetTechPanel().CheckJobUnlocked(InnerJobName)
	visible = bIsUnlocked
	if bIsUnlocked:
		if bHasUnlocked == false:
			emit_signal("OnJobUnlock")
			bHasUnlocked = true

func GetJob():
	return Job

func AssignSlime(slime):
	slime.StartJob(GetJob(), true)


func _on_JobButton_button_down():
	AssignSlime(Helper.GetSlimeAssignPanel().slimeReference)
	Helper.GetSlimeAssignPanel().Close()
	pass # Replace with function body.
