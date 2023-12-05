extends Node2D


var Items = {}

signal OnInventoryUpdate

func _ready():
	pass
	
func AddItem(Reward):
	var resourceType = GameResources.GetResName(Reward.ResourceType)
	var amount = Reward.GetAmount()
	if Items.has(resourceType):
		Items[resourceType] += amount
	else:
		Items[resourceType] = amount
	emit_signal("OnInventoryUpdate")
	Helper.GetSound().Click2()

func CheckIfItemExists(Item, Amount):
	if Items.has(Item):
		return Items[Item] >= Amount
	return false

func RemoveItem(Item, Amount):
	if CheckIfItemExists(Item, Amount):
		Items[Item] -= Amount
		emit_signal("OnInventoryUpdate")
	else:
		print("Could not remove item: " + str(Item) + "(" + str(Amount) + ")" + " from inventory, did not have enough items!")
		
func PrintItems():
	for item in Items:
		print(str(item) + ": " + str(Items[item]))

func GetItemList():
	return Items
	
func GetItemsListToString():
	var itemString = ""
	for item in Items:
		itemString += str(item + ": " + str(Helper.GetFormattedAmount(Items[item])) + "\n")
	if itemString == "":
		itemString = "EMPTY"
	return itemString
