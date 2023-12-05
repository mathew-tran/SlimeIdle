extends Label


var ItemName = ""
var ItemAmount = 0

func Setup(name, amount):
	ItemName = name
	$VBoxContainer/Name.text = ItemName
	UpdateText(amount)
	UpdateTPS(0)
	
func UpdateText(amount):
	$AnimationPlayer.play("RESET")
	if ItemAmount > amount:		
		$AnimationPlayer.play("Remove")
	if ItemAmount < amount:
		$AnimationPlayer.play("Add")
	ItemAmount = amount
	


	$VBoxContainer/Amount.text = "x" + str(ItemAmount)

func UpdateTPS(tps):	
	$VBoxContainer/TPS.text = str(tps)
	
