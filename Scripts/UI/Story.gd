extends Node2D

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$StoryUpgrades.Unlock()
