extends Panel

onready var SlimeName = $HBoxContainer/VBoxContainer/HBoxContainer2/SlimeName

onready var SlimeJob = $HBoxContainer/VBoxContainer/CurrentJobLabel
onready var SlimeAssign = $HBoxContainer/VBoxContainer/HBoxContainer/AssignButton
onready var SlimeStop = $HBoxContainer/VBoxContainer/HBoxContainer/StopTaskButton
onready var SlimeOutput = $HBoxContainer/OutputLabel
var slimeReference = null

func Setup(slime):
	slimeReference = slime
	SlimeName.text = slimeReference.Name
	slimeReference.connect("OnJobStart", self, "UpdateWorkingState")
	slimeReference.connect("OnJobStart", self, "StopIdleAnimation")
	slimeReference.connect("OnJobUpdate", self, "UpdateProgressBar")
	slimeReference.connect("OnJobUpdate", self, "UpdateWorkingState")
	slimeReference.connect("OnJobStop", self, "UpdateWorkingState")
	slimeReference.connect("OnSlimeIdled", self, "ShowIdleAnimation")
	
	if slimeReference.IsIdle():
		ShowIdleAnimation()
	UpdateWorkingState()
	$HBoxContainer/VBoxContainer2/Panel/SlimeSprite.texture = slimeReference.slimeTexture
	$HBoxContainer/VBoxContainer2/Panel/SlimeSprite.flip_h = slimeReference.bIsFlipped

func StopIdleAnimation():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
	
func ShowIdleAnimation():
	$AnimationPlayer.play("Slimeidled")

func UpdateProgressBar():
	if slimeReference.IsStalled():
		$HBoxContainer/VBoxContainer/ProgressBar.value = 0
	else:
		$HBoxContainer/VBoxContainer/ProgressBar.value = slimeReference.GetJobPercent()
	
func UpdateWorkingState():
	SlimeJob.text = slimeReference.GetCurrentJobName()
	$HBoxContainer/RerunSprite.visible = slimeReference.bIsJobRecurring
	SlimeOutput.text = slimeReference.GetOutputString()
	if slimeReference.IsWorking():
		SlimeStop.visible = true
	else:
		SlimeStop.visible = false
		$HBoxContainer/VBoxContainer/ProgressBar.value = 0
		$HBoxContainer/RerunSprite.visible = false
	


func _on_AssignButton_button_down():
	Helper.GetSlimeAssignPanel().Show(slimeReference)
	Helper.GetSound().Click()
	pass # Replace with function body.


func _on_StopTaskButton_button_down():
	slimeReference.StopJob()
	Helper.GetSound().Close()
	pass # Replace with function body.


func _on_Button_button_down():
	Helper.GetSound().Click()
	if slimeReference.IsWorking():
		$AnimationPlayer.play("SlimeClicked")
		if slimeReference.IsStalled() == false:
			var jobTimer = slimeReference.GetJobTimer()
			var changeAmount = jobTimer.time_left - Helper.GetTechPanel().GetSlimeClick()
			if changeAmount <= 0:
				jobTimer.emit_signal("timeout")
			else:
				jobTimer.start(changeAmount)
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SlimeClicked":
		$AnimationPlayer.play("RESET")
	pass # Replace with function body.
