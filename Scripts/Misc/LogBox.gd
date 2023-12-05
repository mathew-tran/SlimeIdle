extends Panel

export var MaxLineAmount = 100
onready var MessageContainer = $ScrollContainer/VBoxContainer

func AddText(newText):
	var newMessage = Label.new()
	var time = OS.get_datetime()
	var display_string : String = "%02d:%02d:%02d" % [time.hour, time.minute, time.second];
	newMessage.text = "[" + display_string + "] "
	newMessage.text += newText
	MessageContainer.add_child(newMessage)
	MessageContainer.move_child(newMessage, 0)
	if MessageContainer.get_child_count() > MaxLineAmount:
		MessageContainer.remove_child(MessageContainer.get_child(MaxLineAmount - 1))
	
